/***************************************************
  This is a sketch to test just the menu for the Portland State
  MME Rocket Manufacturing Capstone curing oven controller. 

  It is heavily based on the example sketch for the Adafruit 1.8" 
  SPI display. The modifications are by 
  Jenner Hanni  <jeh.wicker@gmail.com>
  http://github.com/psas/mme-capstone/
  
  It includes Michael Margolis' Time library that provides a handy
  API for all the time-tracking. Super useful.
  http://www.pjrc.com/teensy/td_libs_Time.html
****************************************************/

/**************************************************
  Original Adafruit notice:

  This is an example sketch for the Adafruit 1.8" SPI display.
  This library works with the Adafruit 1.8" TFT Breakout w/SD card
  ---* http://www.adafruit.com/products/358
  as well as Adafruit raw 1.8" TFT display
  ---* http://www.adafruit.com/products/618
 
  Check out the links above for our tutorials and wiring diagrams
  These displays use SPI to communicate, 4 or 5 pins are required to
  interface (RST is optional)
  Adafruit invests time and resources providing this open source code,
  please support Adafruit and open-source hardware by purchasing
  products from Adafruit!

  Written by Limor Fried/Ladyada for Adafruit Industries.
  MIT license, all text above must be included in any redistribution
 ****************************************************/

// These are the pins for the shield
#define sclk 13
#define mosi 11
#define cs   10
#define dc   8
#define rst  0  

#include <Adafruit_GFX.h>    // Core graphics library
#include <Adafruit_ST7735.h> // Hardware-specific library
#include <SPI.h>
#include <Time.h>

#if defined(__SAM3X8E__)
    #undef __FlashStringHelper::F(string_literal)
    #define F(string_literal) string_literal
#endif

// Option 1: use any pins but a little slower
Adafruit_ST7735 tft = Adafruit_ST7735(cs, dc, mosi, sclk, rst);

float p = 3.1415926;

#define Neutral 0
#define Press 1
#define Up 2
#define Down 3
#define Right 4
#define Left 5

// this needs to be put into an array of step structs
struct stepInfo {
  int rate = 0;
  int temp = 0;
  int secs = 0;
  int elapsed = 0;
  int starttime = 0;
};

struct aState {
  int cur;
  int nL;
  int nU;
  int nR;
  int nD;
  int nS;
};

stepInfo steplist[9];
int maxStep = 1;
int curSetStep = 1;
int curRunStep = 0;

// flags for running the profile
int updateStepFlag = 0;
int reDisplayFlag = 0;
int doneFlag = 0;

aState states[18];
int curState;
int prevState;

int curtemp = 32;
int prevtemp = 32;

time_t reftime = 0;
time_t nowtime = 0;
time_t prevmin = 0;
  
int x = 5;
int y = 5;
int num = 1;
int joy = 0;

int ramprate = 0;

int holdtemp1 = 0;
int holdtemp2 = 0;
int holdtemp3 = 0;

int holdtimehour = 0;
int holdtimemins = 0;
int holdtimesecs = 0;
 
void setup(void) {
  Serial.begin(9600);
  
  // Our supplier changed the 1.8" display slightly after Jan 10, 2012
  // so that the alignment of the TFT had to be shifted by a few pixels
  // this just means the init code is slightly different. Check the
  // color of the tab to see which init code to try. If the display is
  // cut off or has extra 'random' pixels on the top & left, try the
  // other option!
  // If you are seeing red and green color inversion, use Black Tab

  // Our TFT display had a Blue Tab so we use blacktab, don't ask 
  // silly questions like "why?", just do it, blacktab is correct:
  tft.initR(INITR_BLACKTAB);   // initialize a ST7735S chip, black tab

  tft.fillScreen(ST7735_WHITE);
  tft.setTextColor(ST7735_BLACK);
  tft.setRotation(135);
  tft.setTextWrap(false);

  // set the reference for tracking time in seconds
  reftime = now();
  nowtime = now() - reftime;
  Serial.println(nowtime);
  Serial.println(reftime);
  Serial.println("run: ");
  
  delay(500);
  int i = 0;
  
  // init states array with state structs
  // {cur,L,U,R,D,S}
  states[0] = {0,0,0,1,2,0};
  states[1] = {1,0,1,1,1,1};
  states[2] = {2,2,0,6,3,2};
  states[3] = {3,3,2,4,5,4};
  states[4] = {4,4,4,4,4,3};
  states[5] = {5,5,3,5,5,0};
  states[6] = {6,6,6,7,8,6};
  states[7] = {7,6,7,7,7,7};
  states[8] = {8,8,6,9,10,8};
  states[9] = {9,8,9,9,9,9};
  states[10] = {10,10,8,11,14,10};
  states[11] = {11,10,11,12,11,11};
  states[12] = {12,11,12,13,12,12};
  states[13] = {13,12,13,13,13,13};
  states[14] = {14,14,10,15,17,13};
  states[15] = {15,14,15,16,15,15};
  states[16] = {16,15,16,16,16,16};
  states[17] = {17,17,14,17,17,2};

  curState = 0;
  redrawMenu(0);
  displayMenu(curState);
}

void loop() {
  
  // check joystick
  int joy = CheckJoystick();

  // handle joystick movement 
  if (joy != 0) {
    prevState = curState;
    curState = handleJoystick(joy);

    displayMenu(curState);
    delay(100);
  }

  if (curState == 4) {
    displayMenu(curState);
  }

}

// Check the joystick position
int CheckJoystick()
{
  int joystickState = analogRead(3);
  
  if (joystickState < 50) return Left;
  if (joystickState < 150) return Down;
  if (joystickState < 250) return Press;
  if (joystickState < 500) return Right;
  if (joystickState < 650) return Up;
  return Neutral;
}

// get the data out of the selected step in the array
// so we can display the data for that step on the screen
void getStep(int i) {
  ramprate = steplist[i].rate;
  holdtemp1 = (steplist[i].temp/100) % 100;
  holdtemp2 = (steplist[i].temp/10) % 10;
  holdtemp3 = steplist[i].temp % 10;
  holdtimesecs = steplist[i].secs;
  holdtimehour = (holdtimesecs/3600) % 3600;
  holdtimemins = (holdtimesecs/60) % 60;
}

// store the values of the selected step in the array
void setStep(int i) {
  steplist[i].rate = ramprate;
  steplist[i].temp = holdtemp1*100 + holdtemp2*10 + holdtemp3;
  steplist[i].secs = holdtimehour*3600 + holdtimemins*60;
}

int handleJoystick(int joy) {
  switch (joy) {
    case Left:
      if (curState == 9 || curState == 11 || curState == 15)
            setStep(curSetStep);
      return states[curState].nL;
      break;
    case Right:
      return states[curState].nR;
      break;
    case Up:
      switch(states[curState].nU) {
        case 1:
          if (maxStep > 0 && maxStep < 9) {
            maxStep++;
            updateNum(130,20,12,10,maxStep);
          }
          break;
        case 7:
          if (curSetStep < maxStep) {
            curSetStep++;
            getStep(curSetStep);
            redrawMenu(1);
          }
          break;
        case 9:
          if (ramprate < 9) {
            ramprate++;
            updateNum(77,35,12,10,ramprate);
          }
          break;
        case 11:
          if (holdtemp1 < 9) {
            holdtemp1++;
            updateNum(77,50,5,10,holdtemp1);
          }
          break;
        case 12:
          if (holdtemp2 < 9) {
            holdtemp2++;
            updateNum(83,50,5,10,holdtemp2);
          }
          break;
        case 13:
          if (holdtemp3 < 9) {
            holdtemp3++;
            updateNum(89,50,5,10,holdtemp3);
          }
          break;
        case 15:
          if (holdtimehour < 9) {
            holdtimehour++;
            updateNum(77,65,5,10,holdtimehour);
          }
          break;
        case 16:
          if (holdtimemins < 59) {
            holdtimemins++;
            updateNum(95,65,40,10,holdtimemins);
          } 
          break;
        }
      return states[curState].nU;
      break;

    case Down:
      switch(states[curState].nD) {
        case 1:
          if (maxStep > 1 && maxStep < 10) {
            maxStep--;
            updateNum(130,20,12,10,maxStep);
          }
          break;
        case 7:
          if (curSetStep > 1) {
            curSetStep--;
            getStep(curSetStep);
            redrawMenu(1);
          }
          break;
        case 9:
          if (ramprate > 1) {
            ramprate--;
            updateNum(77,35,12,10,ramprate);
          }
          break;
        case 11:
          if (holdtemp1 > 0) {
            holdtemp1--;
            updateNum(77,50,5,10,holdtemp1);
          }
          break;
        case 12:
          if (holdtemp2 > 0) {
            holdtemp2--;
            updateNum(83,50,5,10,holdtemp2);
          }
          break;
        case 13:
          if (holdtemp3 > 0) {
            holdtemp3--;
            updateNum(89,50,5,10,holdtemp3);
          }
          break;
        case 15:
          if (holdtimehour > 0) {
            holdtimehour--;
            updateNum(77,65,5,10,holdtimehour);
          }
          break;
        case 16:
          if (holdtimemins > 0) {
            holdtimemins--;
            updateNum(95,65,40,10,holdtimemins);
          } 
          break;
      }
      return states[curState].nD;
      break;
      
    case Press:
      if (curState == 17)
            setStep(curSetStep);
      return states[curState].nS;
      break;
      
  }
  delay(100);
}

// combined menu that updates previous states for highlighting
void displayMenu(int i){
  tft.setTextColor(ST7735_RED);
  switch(i) {
    case 0: // main menu: maxStep
      if (prevState == 1) {
        tft.setCursor(130,20);
        tft.setTextColor(ST7735_BLACK);
        tft.print(maxStep);
      }
      else if (prevState == 2) {
        tft.setCursor(5,35);
        tft.setTextColor(ST7735_BLACK);
        tft.print("*Define Temp Profile");
      }
      else if (prevState == 5) {
        maxStep = 1;
        curRunStep = 0;
        redrawMenu(0);        
      }
      tft.setTextColor(ST7735_RED);
      tft.setCursor(5,20);
      tft.print("*Number of steps: ");
      break;
    case 1: // main menu: set steps
      if (prevState == 0) {
        tft.setTextColor(ST7735_BLACK);
        tft.fillRect(5,20,100,10,ST7735_WHITE);
        tft.setCursor(5,20);
        tft.print("*Number of steps: ");
      }
      tft.setCursor(130,20);
      tft.setTextColor(ST7735_RED);
      tft.print(maxStep);
      break;
    case 2: // main menu: temp profile
      if (prevState == 0) {
        tft.setTextColor(ST7735_BLACK);
        tft.fillRect(5,20,100,10,ST7735_WHITE);
        tft.setCursor(5,20);
        tft.print("*Number of steps: ");
      }
      else if (prevState == 3) {
        tft.setTextColor(ST7735_BLACK);
        tft.fillRect(5,50,100,10,ST7735_WHITE);
        tft.setCursor(5,50);
        tft.print("*Run Temp Profile");
      }
      else if (prevState == 17) {
        redrawMenu(0);
      }
      tft.setCursor(5,35);
      tft.setTextColor(ST7735_RED);
      tft.print("*Define Temp Profile");
      break;
    case 3: // main menu: run profile
      if (prevState == 2) {
        tft.setTextColor(ST7735_BLACK);
        tft.fillRect(5,35,100,10,ST7735_WHITE);
        tft.setCursor(5,35);
        tft.print("*Define Temp Profile");        
      }
      else if (prevState == 4) {
        redrawMenu(0);
        doneFlag = 0;
        
      }
      else if (prevState == 5) {
        tft.setTextColor(ST7735_BLACK);
        tft.fillRect(5,65,100,10,ST7735_WHITE);
        tft.setCursor(5,65);
        tft.print("*Reset Profile");
      }
      tft.setTextColor(ST7735_RED);
      tft.setCursor(5,50);
      tft.print("*Run Temp Profile");
      break;
    // case 4 handles all running of the program
    // - tracks time in seconds 
    // - reads the thermocouples
    // - controls the relays on/off as necessary
    // - displays all this data on the run screen
    // but it does all this inside displayRunScreen()
    case 4: // main menu: running screen
      if (prevState == 3) {
        updateStepFlag = 1;
        reDisplayFlag = 1;
        curRunStep = 1;
      }
      Serial.println("hello.");
      if (doneFlag == 1) {
        doneFlag = 1;
      }
      else {
        int rtn = displayRunScreen();
        if (rtn == -1) {
          Serial.println("Your program is complete.");
          tft.fillScreen(ST7735_WHITE);    
          tft.setTextColor(ST7735_BLACK);
          tft.setCursor(5, 5);
          tft.println("Your program is complete."); 
          tft.setTextColor(ST7735_RED);
          tft.setCursor(5, 20);
          tft.println("*Press button to go back."); 
          doneFlag = 1;
        }
      }
      prevState = curState;
      break;
    case 5: // main menu: reset profile
    if (prevState == 3) {
      tft.setTextColor(ST7735_BLACK);
      tft.setCursor(5,50);
      tft.print("*Run Temp Profile");
    }
      tft.setTextColor(ST7735_RED);
      tft.setCursor(5,65);
      tft.print("*Reset Profile");
      break;
    case 6: // temp profile: which step
      if (prevState == 2) {
        redrawMenu(1);
      }
      else if (prevState == 8) {
        tft.setTextColor(ST7735_BLACK);
        tft.setCursor(5,35);
        tft.print("*Ramp Rate: ");      
      }
      tft.setTextColor(ST7735_RED);
      tft.setCursor(5,20);
      tft.print("*Step: ");
      tft.setCursor(50,20);
      tft.setTextColor(ST7735_BLACK);
      tft.print(curSetStep);
      break;
    case 7: // temp profile: set step
      tft.setTextColor(ST7735_BLACK);
      tft.setCursor(5,20);
      tft.print("*Step: "); 
      tft.setTextColor(ST7735_RED);
      tft.setCursor(50,20);
      tft.print(curSetStep);
      break;
    case 8: // temp profile: ramp rate
      if (prevState == 6) {
        tft.setTextColor(ST7735_BLACK);
        tft.setCursor(5,20);
        tft.print("*Step: ");
      }
      else if (prevState == 9) {
        tft.setCursor(5,35);
        tft.setTextColor(ST7735_BLACK);
        tft.print("*Ramp Rate: ");      
        tft.print(ramprate);
      }
      else if (prevState == 10) {
        tft.setTextColor(ST7735_BLACK);
        tft.setCursor(5,50);
        tft.print("*Hold Temp: ");
        tft.print(holdtemp1);
        tft.print(holdtemp2);
        tft.print(holdtemp3);
        tft.print(" F");
      }
      tft.setTextColor(ST7735_RED);
      tft.setCursor(5,35);
      tft.print("*Ramp Rate: ");      
      break;
    case 9: // temp profile: set rate
      tft.setTextColor(ST7735_BLACK);
      tft.setCursor(5,35);
      tft.print("*Ramp Rate: ");      
      tft.setTextColor(ST7735_RED);
      tft.print(ramprate);
      break;
    case 10: // temp profile: hold temp
      if (prevState == 8) {
      tft.setTextColor(ST7735_BLACK);
      tft.setCursor(5,35);
      tft.print("*Ramp Rate: ");
      tft.print(ramprate);
      }
      else if (prevState == 14) {
        tft.setCursor(5,65);
        tft.setTextColor(ST7735_BLACK);
        tft.print("*Hold Time: ");
        tft.print(holdtimehour);
        tft.print("h ");
        tft.print(holdtimemins);
        tft.print("m");
      }
      tft.setCursor(5,50);
      tft.setTextColor(ST7735_RED);
      tft.print("*Hold Temp: ");
      tft.setTextColor(ST7735_BLACK);
      tft.print(holdtemp1);
      tft.print(holdtemp2);
      tft.print(holdtemp3);
      tft.print(" F");
      break;
    case 11: // temp profile: set temp1
      tft.setCursor(5,50);
      tft.setTextColor(ST7735_BLACK);
      tft.print("*Hold Temp: ");
      tft.setTextColor(ST7735_RED);
      tft.print(holdtemp1);
      tft.setTextColor(ST7735_BLACK);
      tft.print(holdtemp2);
      tft.print(holdtemp3);
      tft.print(" F");
      break;
    case 12: // temp profile: set temp2
      tft.setCursor(5,50);
      tft.setTextColor(ST7735_BLACK);
      tft.print("*Hold Temp: ");
      tft.print(holdtemp1);
      tft.setTextColor(ST7735_RED);
      tft.print(holdtemp2);
      tft.setTextColor(ST7735_BLACK);
      tft.print(holdtemp3);
      tft.print(" F");
      break;
    case 13: // temp profile: set temp3
      tft.setCursor(5,50);
      tft.setTextColor(ST7735_BLACK);
      tft.print("*Hold Temp: ");
      tft.print(holdtemp1);
      tft.print(holdtemp2);
      tft.setTextColor(ST7735_RED);
      tft.print(holdtemp3);
      tft.setTextColor(ST7735_BLACK);
      tft.print(" F");
      break;
    case 14: // temp profile: hold time
      if (prevState == 10) {
        tft.setCursor(5,50);
        tft.setTextColor(ST7735_BLACK);
        tft.print("*Hold Temp: ");
        tft.print(holdtemp1);
        tft.print(holdtemp2);
        tft.print(holdtemp3);
        tft.print(" F");
      }
      else if (prevState == 17) {
        tft.setCursor(5,80);
        tft.setTextColor(ST7735_BLACK);
        tft.print("*Back to Main Menu");
      }
      else if (prevState == 15) {
      }
      tft.setCursor(5,65);
      tft.setTextColor(ST7735_RED);
      tft.print("*Hold Time: ");
      tft.setTextColor(ST7735_BLACK);
      tft.print(holdtimehour);
      tft.print("h ");
      tft.print(holdtimemins);
      tft.print("m");
      break;
    case 15: // temp profile: set time (h)
      tft.setCursor(5,65);
      tft.setTextColor(ST7735_BLACK);
      tft.print("*Hold Time: ");
      tft.setTextColor(ST7735_RED);
      tft.print(holdtimehour);
      tft.setTextColor(ST7735_BLACK);
      tft.print("h ");
      tft.print(holdtimemins);
      tft.print("m");
      break;
    case 16: // temp profile: set time (m)
      tft.setCursor(5,65);
      tft.setTextColor(ST7735_BLACK);
      tft.print("*Hold Time: ");
      tft.print(holdtimehour);
      tft.print("h ");
      tft.setTextColor(ST7735_RED);
      tft.print(holdtimemins);
      tft.setTextColor(ST7735_BLACK);
      tft.print("m");
      break;
    case 17: // temp profile: back to main menu
      if (prevState == 14) {
        tft.setCursor(5,65);
        tft.setTextColor(ST7735_BLACK);
        tft.print("*Hold Time: ");
        tft.print(holdtimehour);
        tft.print("h ");
        tft.print(holdtimemins);
        tft.print("m");
      }
      tft.setTextColor(ST7735_RED);
      tft.setCursor(5,80);
      tft.print("*Back to Main Menu");
      break;
  }
  
}

// redraw the entire main or temp profile menus
void redrawMenu(char which) {
  if (which == 0) { // main menu
    tft.fillScreen(ST7735_WHITE);    
    tft.setTextColor(ST7735_BLACK);
    tft.setCursor(5, 5);
    tft.println("Main Menu");
    tft.drawFastHLine(0,16,tft.width(),ST7735_BLACK);
    tft.setCursor(5,20);
    tft.print("*Number of steps: ");
    tft.setCursor(130,20);
    tft.print(maxStep);
    tft.setCursor(5,35);
    tft.print("*Define Temp Profile");
    tft.setCursor(5,50);
    tft.print("*Run Temp Profile");
    tft.setCursor(5,65);
    tft.print("*Reset Profile");    
  }
  else if (which == 1) { // temp profile menu
    tft.fillScreen(ST7735_WHITE);
    tft.setTextColor(ST7735_BLACK);
    tft.setCursor(5, 5);
    tft.println("Set Temp Profile");
    tft.drawFastHLine(0,16,tft.width(),ST7735_BLACK);
    tft.setCursor(5,20);
    tft.print("*Step: ");
    tft.setCursor(50,20);
    tft.print(curSetStep);
    tft.setCursor(5,35);
    tft.print("*Ramp Rate: ");
    tft.print(ramprate);
    tft.print(" F/sec");
    tft.setCursor(5,50);
    tft.print("*Hold Temp: ");
    tft.print(holdtemp1);
    tft.print(holdtemp2);
    tft.print(holdtemp3);
    tft.print(" F");
    tft.setCursor(5,65);
    tft.print("*Hold Time: ");
    tft.print(holdtimehour);
    tft.print("h ");
    tft.print(holdtimemins);
    tft.print("m");
    tft.setCursor(5,80);
    tft.print("*Back to Main Menu");
  }
  else return;
}

// display run screen with status info
int displayRunScreen() {

  // update temp; don't handle, just update
  
  // update number of seconds since startup
  // don't handle, just update
  nowtime = now() - reftime;

  // this is the first time into a new step
  // set the start time of the step
  // and turn off the flag
  if (updateStepFlag == 1) {
    prevmin = 0;
    steplist[curRunStep].starttime = nowtime;
    updateStepFlag = 0;
  }
  
  // in any case, update the step's elapsed time
  steplist[curRunStep].elapsed = nowtime - steplist[curRunStep].starttime;

  // explicitly tell the function to redraw the screen
  if (reDisplayFlag == 1) {
    reDisplayFlag = 0;

    // redraw the run screen    
    tft.fillScreen(ST7735_WHITE);
    tft.setTextColor(ST7735_BLACK);
    tft.setCursor(5, 5);
    tft.println("Temp Profile Running");
    tft.drawFastHLine(0,16,tft.width(),ST7735_BLACK);
    tft.setCursor(5,20);
    tft.print("Status: ");
    tft.print("ramp or hold");
    tft.setCursor(5,35);
    tft.print("Current Step: "); 
    tft.print(curRunStep);
    tft.print(" of ");
    tft.print(maxStep);
    tft.setCursor(5,50);
    tft.print("Current Temp: ");
    tft.print(curtemp);
    tft.setCursor(5,65);
    tft.print("Step Time: ");
    tft.print(hour(steplist[curRunStep].elapsed));
    tft.print("h ");
    tft.print(minute(steplist[curRunStep].elapsed));
    tft.print("m elapsed of ");
    tft.print(hour(steplist[curRunStep].secs));
    tft.print("h ");
    tft.print(minute(steplist[curRunStep].secs));
    tft.print("m");
    tft.setCursor(5,80);
    tft.print("Total Time Left: 4h 35m");
    tft.setCursor(5,95);
    tft.setTextColor(ST7735_RED);
    tft.print("*Press Button to Cancel");
  }
  
  // handle the temperature
  // control the relays as appropriate
  //if (curtemp < steplist[curRunStep].temp) {
  //  digitalWrite(heater1, HIGH);  // turn on the heaters
  //  delay(100);
  //}

  // if the temp has incremented, redraw the run screen
  if (curtemp != prevtemp) { 
     reDisplayFlag = 1;
     prevtemp = curtemp; 
     Serial.println("End of a step for temp change.");
  }

  
  // handle the time
  // see if we've reached the end of a step
  if (steplist[curRunStep].elapsed > steplist[curRunStep].secs) {
    if (curRunStep < maxStep) { 
      curRunStep++;
      updateStepFlag = 1;
      reDisplayFlag = 1;
      Serial.println("End of a step for time.");
    }
    else 
      return -1;
  }
  // if the minute has incremented, redraw the run screen
  if (minute(steplist[curRunStep].elapsed) > prevmin) {
    prevmin = steplist[curRunStep].elapsed;
    reDisplayFlag = 1;
    Serial.println("Minute incremented, redraw run screen.");
  }

}

void updateNum(int x, int y, int w, int h, int num) {
  tft.fillRect(x,y,w,h,ST7735_WHITE);
  tft.setCursor(x,y);
  tft.setTextColor(ST7735_RED);
  tft.print(num);
  if (curState == 16) {
    tft.setTextColor(ST7735_BLACK);
    tft.print("m");
  }
}


