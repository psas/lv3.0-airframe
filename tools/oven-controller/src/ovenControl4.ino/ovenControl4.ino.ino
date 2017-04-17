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

int ADCThreshold       =  900;
int timeDelay          =  5000;
int serialDelay        =  20;

double startTime;
double currTime;

// Thermocouple readings
float TCP1  = -1;
float TCP2  = -1;
float TCP3  = -1;
float TCP4  = -1;
float TCP5  = -1;

// Thermocouples
Adafruit_MAX31855 thermocouple1(thermoCLK, thermoCS1, thermoDO);
Adafruit_MAX31855 thermocouple2(thermoCLK, thermoCS2, thermoDO);
Adafruit_MAX31855 thermocouple3(thermoCLK, thermoCS3, thermoDO);
Adafruit_MAX31855 thermocouple4(thermoCLK, thermoCS4, thermoDO);
Adafruit_MAX31855 thermocouple5(thermoCLK, thermoCS5, thermoDO);


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(heaterPins1, OUTPUT);
  pinMode(heaterPins2, OUTPUT);
  // wait for MAX chip to stabilize
  delay(1000);
  Serial.println("MAX31855 test");
  startTime= millis();
}

void loop() {
  // put your main code here, to run repeatedly:
  startTime=millis(); 
  Serial.print("TCP1:\t");
  Serial.print(thermocouple1.readFarenheit());
  Serial.print("\nTCP2:\t");
  Serial.print(thermocouple2.readFarenheit());
  Serial.print("\nTCP3:\t");
  Serial.print(thermocouple2.readFarenheit());
  Serial.print("\nTCP4:\t");
  Serial.print(thermocouple2.readFarenheit());
  Serial.print("\nTCP5:\t");
  Serial.print(thermocouple2.readFarenheit());
}
