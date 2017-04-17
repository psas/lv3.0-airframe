/********************************************

 This is oven control shield code v3 written by 
 Thanh Tung Nguyen and Jenner Hanni, 2014. 
 http://github.com/wicker/oven-controller/
 
 This is an oven control sketch for the Adafruit 1.8" TFT
 shield with joystick stacked on a PSAS Airframes Team 
 Oven Control Shield v3 stacked on an Arduino Uno.
 
 Our LCD shield is the BLACKTAB version.
 
 The display, SD card, and five MAX31855 thermocouple-
 to-digital chips are all on the SPI bus. The SD card 
 also uses the SD library. 
 
 We referenced code written by Limor Fried/Ladyada
 for Adafruit Industries under the MIT license.

 GENERIC TODO: Everything related to SD card.
 Otherwise look for TODO notes in comments.
 
 *******************************************/
  
#include <Adafruit_MAX31855.h>
#include <Adafruit_ST7735.h>
#include <Adafruit_GFX.h>
#include <SD.h>
#include <SPI.h>

#define OFF 0
#define ON  1

// assign state values
#define START   1
#define RUNNING 2
#define STOP    3
#define STOPPED 4

// assign joystick positions
#define BUTTON_NONE 0
#define BUTTON_DOWN 1
#define BUTTON_RIGHT 2
#define BUTTON_SELECT 3
#define BUTTON_UP 4
#define BUTTON_LEFT 5

// Pins connection
int swReset       = 0;
int thermoCS1     = 1;
int thermoCS2     = 2;
int thermoCS3     = 3;
int sdCS          = 4;
int heater1       = 5;
int heater2       = 6;
int thermoCS4     = 7;
int lcdDC         = 8;
int thermoCS5     = 9;
int lcdCS         = 10;
int spiMOSI       = 11;
int spiMISO       = 12;
int spiCLK        = 13;
int swStart       = A0;
int fan           = A1;
int vent          = A2;
int joyRead       = A3;

// initialize the LCD screen
Adafruit_ST7735 tft = Adafruit_ST7735(lcdCS, lcdDC, swReset);

// shouldn't these be #defines or at least const double, const int, etc?
double tempSet         =  350;        // farenheit
double tempInc         =  3 ;         // Temperature increament per minutes
double tempErrRange    =  0;
double tempThreshold   =  3;          // Temperature limit to turn on both heaters
int ADCThreshold       =  900;
int timeDelay          =  5000;
float timeMax          =  12780;      // (sec) timeMax=time_ramping+time_at_350; (set at 2 hours), initial temp: 70*F
bool statusFlag        = 0;

// calibration 
double sensor1  =  0;
double sensor2  =  -4;
double sensor3  =  0;
double sensor4  =  0;
double sensor5  =  0;

// variables
double tempErr;
double tempSensor1;
double tempSensor2;
double tempSensor3;
double tempSensor4;
double tempSensor5;
double tempAverage;
double tempInitial;         // room temp

double currTempSet;
double tempSetLow;
double tempSetHigh;

double startTime;
double currTime;

uint8_t buttonhistory  =  0;
uint8_t joystickVal = 0;

// Thermocouples
Adafruit_MAX31855 thermocouple1(spiCLK, thermoCS1, spiMISO);
Adafruit_MAX31855 thermocouple2(spiCLK, thermoCS2, spiMISO);
Adafruit_MAX31855 thermocouple3(spiCLK, thermoCS3, spiMISO);
Adafruit_MAX31855 thermocouple4(spiCLK, thermoCS4, spiMISO);
Adafruit_MAX31855 thermocouple5(spiCLK, thermoCS5, spiMISO);

// Set the first and second heaters to ON or OFF.
void set_heaters(int val1, int val2) {
  digitalWrite(heater1, val1);  // turn off the heaters
  delay(100);
  digitalWrite(heater2, val2);  // turn off the heaters
  delay(100);
}

// Read the joystick and save the value in joystickVal.
void read_joystick() {

  float a = analogRead(3);

  a *= 5.0;
  a /= 1024.0;
  
  Serial.print("Button read analog = ");
  Serial.println(a);
  if (a < 0.2) joystickVal = BUTTON_DOWN;
  if (a < 1.0) joystickVal = BUTTON_RIGHT;
  if (a < 1.5) joystickVal = BUTTON_SELECT;
  if (a < 2.0) joystickVal = BUTTON_UP;
  if (a < 3.2) joystickVal = BUTTON_LEFT;
  else         joystickVal = BUTTON_NONE;
}

// Read the start button and update the state machine.
// Possible states are START, RUNNING, STOP, and STOPPED.
// The state is updated and the timer is incremented or
// reset to zero, depending on state.
//
// Possibly better to rename this update_state_machine().
void handle_start_button() {

  uint8_t ADCReading;

  // if the input is HIGH, handle it as a START
  if (ADCReading > ADCThreshold) {
    if (statusFlag == START) {
      statusFlag = RUNNING;
      // set start time
      startTime = millis(); 
      currTime = millis()-startTime;
      // set start temperature
      check_temp_sensors();
      tempInitial = tempAverage;
    }
    else if (statusFlag == RUNNING) {
      // check if timer has reached end of profile time
      if (currTime/1000 >= timeMax)
        statusFlag = STOP;
      else
        statusFlag = RUNNING;
      currTime = millis()-startTime;
    }
    else if (statusFlag == STOP) {
      statusFlag = STOPPED;
      currTime = 0;
    }
    else { 
      statusFlag = START;
      currTime = 0;
    }
  }

  // otherwise the input is LOW, handle it as a STOP
  else {
    if (statusFlag == START) {
      statusFlag = STOP;
      currTime = millis()-startTime;
    }
    else if (statusFlag == RUNNING) {
      statusFlag = STOP;
      currTime = millis()-startTime;
    }
    else if (statusFlag == STOP) {
      statusFlag = STOPPED;
      currTime = 0;
    }
    else { 
      statusFlag = STOPPED;
      currTime = 0;
    }
  }
}

// Poll each thermocouple value and get an average value.
// Adjusting by 32 for each tempSensor value
// eliminates the SPI disconnection.
void check_temp_sensors() {
  float tempSum=0;
  int count=0;
  tempSensor1 = thermocouple1.readFarenheit()+sensor1;
  if (tempSensor1>32) {
    count=count+1;
    tempSum=tempSum+tempSensor1;
  }
  delay(10);
  tempSensor2 = thermocouple2.readFarenheit()+sensor2;
  if (tempSensor2>32) {
    count=count+1;
    tempSum=tempSum+tempSensor2;
  }
  delay(10);
  tempSensor3 = thermocouple3.readFarenheit()+sensor3;
  if (tempSensor3>32) {
    count=count+1;
    tempSum=tempSum+tempSensor3;
  }
  delay(10);
  tempSensor4 = thermocouple4.readFarenheit()+sensor4;
  if (tempSensor4>32) {
    count=count+1;
    tempSum=tempSum+tempSensor4;
  }
  delay(10);
  tempSensor5 = thermocouple5.readFarenheit()+sensor5;
  if (tempSensor5>32) {
    count=count+1;
    tempSum=tempSum+tempSensor5;
  }
  delay(10);
  tempAverage = tempSum/count;
}

// TODO: FIGURE THIS OUT AND EXPLAIN IT BETTER
// Not sure exactly what this is doing.
// It's deciding how to update the heaters, anyway.
// This really ought to take the state use it.
void update_heaters(int state) {
  currTempSet=min(350, currTime/1000/60*tempInc+tempInitial);
  tempSetLow= currTempSet-tempErrRange;
  tempSetHigh= currTempSet+tempErrRange;  

  if (tempAverage < tempSetLow && tempAverage > 32) {
    if (tempAverage < tempSetLow - tempThreshold) 
      set_heaters(ON,ON);
    else 
      set_heaters(ON,OFF);
  }
  else {
    if (tempAverage > tempSetHigh + tempThreshold)
      set_heaters(OFF,OFF);
    else 
      set_heaters(OFF,ON);
  }
}

// Display information
// TODO: EVERYTHING
void update_display() {
  Serial.print("Current temperature F = ");
  Serial.print(tempSensor1);
  Serial.print(" ");
  Serial.print(tempSensor2);
  Serial.print(" ");
  Serial.print(tempSensor3);
  Serial.print(" ");
  Serial.print(tempSensor4);
  Serial.print(" ");
  Serial.print(tempSensor5); 
  Serial.print("Average temperature F = ");
  Serial.println(tempAverage);

  read_joystick();
  uint8_t b = joystickVal;
  tft.setTextSize(3);
  if (b == BUTTON_DOWN) {  
    tft.setTextColor(ST7735_RED);
    tft.setCursor(0, 10);
    tft.print("Down ");
    buttonhistory |= 1;
  }
  if (b == BUTTON_LEFT) {
    tft.setTextColor(ST7735_YELLOW);
    tft.setCursor(0, 35);
     tft.print("Left ");
    buttonhistory |= 2;
  }
  if (b == BUTTON_UP) {
    tft.setTextColor(ST7735_GREEN);
    tft.setCursor(0, 60);
    tft.print("Up"); 
    buttonhistory |= 4;
  }
  if (b == BUTTON_RIGHT) {
    tft.setTextColor(ST7735_BLUE);
    tft.setCursor(0, 85);
    tft.print("Right");
    buttonhistory |= 8;
  }
  if ((b == BUTTON_SELECT) && (buttonhistory == 0xF)) {
    tft.setTextColor(ST7735_MAGENTA);
    tft.setCursor(0, 110);
    tft.print("SELECT");
    buttonhistory |= 8;
    delay(2000);
    Serial.print("Initializing SD card...");
    if (!SD.begin(sdCS)) {
      Serial.println("failed!");
      return;
    }
  }
}

// Set up all the pins and serial connection
void setup() {
  Serial.begin(9600);
  
  // set up the pins
  pinMode(heater1, OUTPUT);
  pinMode(heater2, OUTPUT);
  pinMode(fan, OUTPUT);
  pinMode(vent, OUTPUT);
  
  // wait for MAX chips to stabilize
  delay(1000);
  set_heaters(OFF,OFF);

  // get the initial oven temperature
  check_temp_sensors();
  tempInitial = tempAverage;
 
  // init the LCD and fill screen
  tft.initR(INITR_BLACKTAB);
  tft.fillScreen(0x0000);

  // init the LCD with user selection
  // TODO: ADD A GET_PROFILE OR SOMETHING TO GET INFO FROM USER
  // AND WORK THAT INTO THE STATE MACHINE LOGIC
}

// TODO: VERIFY THIS LOGIC
// TODO: FIGURE OUT WHERE DELAYS ARE NECESSARY AND ADD THEM
void loop() {

  // get inputs
  read_joystick();
  check_temp_sensors();

  // update state machine based on those inputs
  handle_start_button();
  update_heaters(statusFlag);

  // update display
  update_display();

  delay(100);

} 

