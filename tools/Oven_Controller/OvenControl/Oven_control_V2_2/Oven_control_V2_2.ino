/*************************************************** 
  On/ Off control 1 thermocouples 
 ****************************************************/

#include "Adafruit_MAX31855.h"

// Pins connection
int thermoDO      = 3;
int thermoCLK     = 4;
int thermoCS1     = 5;
int thermoCS2     = 6;
int thermoCS3     = 7;
int thermoCS4     = 8;
int thermoCS5     = 9;
int thermoCS6     = 10;
int heaterPins1   = 11;
int heaterPins2   = 12;
int swStart       = A0;
int swMode1       = A1;
int swMode2       = A2;
int swMode3       = A3;

// Indicate status variables: 0 off; 1: on
int mode1      =  0;
int mode2      =  0;
int mode3      =  0;
int start      =  0;
int stopnow    =  0;
int Status     =  1;

// constant
double tempSet         =  350;        // farenheit
double tempInc         =  3 ;         // Temperature increament per minutes
double tempErrRange    =  0;
double tempThreshold   =  3;          // Temperature limit to turn on both heaters
int ADCThreshold       =  900;
int timeDelay          =  5000;
int serialDelay        =  20;
float holdTime         =  7200;      // (sec) 2 hours
float holdPoint        =  0;
// calibration 

double sensor1  =  0;
double sensor2  =  0;
double sensor3  =  0;
double sensor4  =  0;
double sensor5  =  0;
double sensor6  =  0;


// variables
double tempErr;
double tempSensor1;
double tempSensor2;
double tempSensor3;
double tempSensor4;
double tempSensor5;
double tempSensor6;
double tempAverage;
double tempInitial;         // room temp

double currTempSet;
double tempSetLow;
double tempSetHigh;

double startTime;
double currTime;

// Thermocouples
Adafruit_MAX31855 thermocouple1(thermoCLK, thermoCS1, thermoDO);
Adafruit_MAX31855 thermocouple2(thermoCLK, thermoCS2, thermoDO);
Adafruit_MAX31855 thermocouple3(thermoCLK, thermoCS3, thermoDO);
Adafruit_MAX31855 thermocouple4(thermoCLK, thermoCS4, thermoDO);
Adafruit_MAX31855 thermocouple5(thermoCLK, thermoCS5, thermoDO);
Adafruit_MAX31855 thermocouple6(thermoCLK, thermoCS6, thermoDO);


void all_heaters_off()
{
  digitalWrite(heaterPins1, LOW);  // turn off the heaters
  delay(100);
  digitalWrite(heaterPins2, LOW);  // turn off the heaters
  Serial.println("  OFF");  
}

void one_heater_off()
{
  digitalWrite(heaterPins1, LOW);  // turn off the heaters
  delay(100);
  Serial.println("  1 OFF");  
}

void all_heaters_on()
{
  digitalWrite(heaterPins1, HIGH);  // turn on the heaters
  delay(100);
  digitalWrite(heaterPins2, HIGH);  // turn on the heaters
  delay(100);
  Serial.println("  ON");  
}
 
void one_heater_on()
{
  digitalWrite(heaterPins1, HIGH);  // turn on the heaters
  delay(100);
  Serial.println("  1 ON");  
} 
  
void setup() {
  Serial.begin(9600);
  pinMode(heaterPins1, OUTPUT);
  pinMode(heaterPins2, OUTPUT);
  // wait for MAX chip to stabilize
  delay(1000);
  all_heaters_off();
  Serial.println("MAX31855 test");
  startTime= millis();
  Status='RAMPING';  
}

int scan_button(int swButton)
{
  int ADCreading = analogRead(swButton);
//  Serial.println(ADCreading);
  if (ADCreading < ADCThreshold) 
         return (1);
  else   return (0);
}

void tempPrint()
{
  Serial.print("Current temperature F = ");
 // Serial.println(tempSensor1,"\t", tempSensor2,"\t",tempSensor3,"\t",tempSensor4,"\t",tempSensor5,"\t",tempSensor6);
  Serial.print(tempSensor1);
  Serial.print(" ");
  Serial.print(tempSensor2);
  Serial.print(" ");
  Serial.print(tempSensor3);
  Serial.print(" ");
  Serial.print(tempSensor4);
  Serial.print(" ");
  Serial.print(tempSensor5);
  Serial.print(" ");
  Serial.println(tempSensor6);  
  Serial.print("Average temperature F = ");
  Serial.println(tempAverage);
  if (Status=1) 
  { 
    Serial.println("RAMPING");
  }
  else Serial.println("HOLDING");
}


void sensors_reading()
{
    // scanning all of the sensors and switches
  mode1 = scan_button(swMode1);
  mode2 = scan_button(swMode2);
  start = scan_button(swStart);
  float tempSum=0;
  int count=0;
  tempSensor1 = thermocouple1.readFarenheit()+sensor1;
  if (tempSensor1>32) // eliminate the SPI disconection 
    {
      count=count+1;
      tempSum=tempSum+tempSensor1;
    }
  delay(serialDelay);
  //tempSensor2 = thermocouple2.readFarenheit()+sensor2;
  //if (tempSensor2>32) // eliminate the SPI disconection 
  //  {
  //    count=count+1;
  //    tempSum=tempSum+tempSensor2;
  //  }
  delay(serialDelay);
  tempSensor3 = thermocouple3.readFarenheit()+sensor3;
    if (tempSensor3>32) // eliminate the SPI disconection 
    {
      count=count+1;
      tempSum=tempSum+tempSensor3;
    }
  delay(serialDelay);
  //tempSensor4 = thermocouple4.readFarenheit()+sensor4;
    //if (tempSensor4>32) // eliminate the SPI disconection 
    //{
    //  count=count+1;
     // tempSum=tempSum+tempSensor4;
    //}
  //delay(serialDelay);
  tempSensor5 = thermocouple5.readFarenheit()+sensor5;
    /*if (tempSensor5>32) // eliminate the SPI disconection 
    {
      count=count+1;
      tempSum=tempSum+tempSensor5;
    }*/
  //delay(10);
  //tempSensor6 = thermocouple6.readFarenheit()+sensor6;
    /*if (tempSensor6>32) // eliminate the SPI disconection 
    {
      count=count+1;
      tempSum=tempSum+tempSensor6;
    }*/
  tempAverage = tempSum/count;
  tempPrint();
}

void loop() {
  all_heaters_off();
  sensors_reading();
  tempInitial = tempAverage;         // initial start temp
  startTime=millis(); 
  // compared and controled
  while (start&(!stopnow))
  {
    currTime=millis()-startTime;   
    currTempSet=min (350, currTime/1000/60*tempInc+tempInitial);
    if ((currTempSet == 350)&&(Status))
      {
         Status =0;
         holdPoint=currTime;        // save the time when holding start
      }
    Serial.print("Set temperature     F = ");
    Serial.println(currTempSet);
    tempSetLow= currTempSet-tempErrRange;
    tempSetHigh= currTempSet+tempErrRange;  
 
    if ((tempAverage<tempSetLow)&&(tempAverage>32) ) 
    {
      if (tempAverage<tempSetLow-tempThreshold) all_heaters_on();
      else one_heater_on();
    }
    else
    {
      if (tempAverage>tempSetHigh+tempThreshold)
      {
        all_heaters_off();
      } 
      else one_heater_off();
    }
    if ((currTime-holdPoint)/1000>=holdTime)
      {
        stopnow=1;
      }
    delay(timeDelay);
    sensors_reading();
   }
  if (stopnow)
  {
    Serial.println("Mission complete, please wait until the oven cold down");
    while(1);  // stay here until turn off the controller.
  }
  delay(timeDelay);
} 

