/*
  CS362 Final Project - Arduino Security System
  
  Author: Bradley Golden
 
 References:
 Magnet Switch:
 http://www.arduino.cc/en/Tutorial/Button
 Anode LED;
 https://learn.adafruit.com/adafruit-arduino-lesson-3-rgb-leds/breadboard-layout
 Keypad:
 http://arduino.cc/en/Tutorial/InputPullupSerial
 http://arduino.cc/en/Reference/pinMode
 */
 
 /**************Initialize Security System Variable**************/
 int warningActive = 0;
 int systemActive = 0;
 const int ON = 1;
 const int OFF = 0;
 int currColor[] = {0,0,0};
 int systemCode[] = {1,2,3,4};
 const int DISARM = 0;
 const int ARM = 1;
 const int DELAY = 2;
 const int delayAmount = 30; //30 seconds
 int currRGB[] = {0,0,0};
 /*
 //if number corresponding to systemCode 
 is pressed set correspoding index in systemBool to 1
 */
 int systemBool[] = {0,0,0,0};

/**************Initialize Magnet Door Switch**************/
const int magnetPin = 2;
int magnetState = 0;

/**************Initialize Tricolor Anode LED**************/
const int redPin = 11;
const int greenPin = 10;
const int bluePin = 9;
#define COMMON_ANODE

/**************Initialize Keypad**************/
const int keypadPin[] = {4,5,6,7};
int keypadState = 0;

/**************Initialize Stack Implementation**************/
int top = -1;
int stack[] = {0,0,0,0};


void setup() {
  // initialize the Serial Monitor @ 9600
  Serial.begin(9600);  
  setupMagnet();
  setupLED();
  setupKeypad();
  activateSystem();
}

void loop(){
  checkDoorOpen();
  
  if(doorIsOpen()){
    toggleWarning(ON);
  }
  //door has been opened
  if(warningActive){
   allowKeypadEntry(DISARM); //DISARM
  }
  //door is closed and the client wants to exit the building
  else{
    allowKeypadEntry(DELAY); //DELAY ARM by 30 seconds
  }
  //TODO -- if 30 seconds and warning active
  //send text message
}

void setupLED(){
  // initialize the ANNODE pins as an output
  pinMode(redPin, OUTPUT);    
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
}

void setupMagnet(){
  pinMode(magnetPin, INPUT); // initialize the magnetswtich pin as an input
}

void setupKeypad(){
  // initialize the keypad pin(s) as an input:
  for(int x=0; x<4; x++)
  {
    pinMode(keypadPin[x], INPUT_PULLUP); 
  }
}

void setColor(int red, int green, int blue)
{
  #ifdef COMMON_ANODE
    red = 255 - red;
    green = 255 - green;
    blue = 255 - blue;
  #endif
  currRGB[0] = red;
  currRGB[1] = green;
  currRGB[2] = blue;
  analogWrite(redPin, red);
  analogWrite(greenPin, green);
  analogWrite(bluePin, blue);  
}

void activateSystem(){
  setColor(0,0,255);
  systemActive = 1;
}

void checkDoorOpen(){
  // read the state of the magnet value:
  magnetState = digitalRead(magnetPin);
}

int doorIsOpen() {
  if (magnetState == LOW) {
    Serial.println("Door is open");
    return 1;
  }
  return 0;
}

void toggleWarning(int enable){
  if(enable){
    setColor(255, 255, 0);
    warningActive = 1;
  }
  else {
    warningActive = 0;
  }
}

void flashLED(int red, int green, int blue, int time){
    setColor(red, green, blue);
    delay(time);
    setColor(255, 255, 0);
    //setColor(currRGB[0], currRGB[1], currRGB[2]);
}
 
 void allowKeypadEntry(int command){
   int pin[] = {5, 4, 7, 6};
   
   for(int x=0; x<4; x++){
    //signifying the state of which the button is in by reading the appropriate pin #
    keypadState = digitalRead(keypadPin[x]);
    
    // check if the pushbutton on the keypad is pressed.
    // if it is, the keypadState is LOW:
    for(int y=0; y<4; y++){
      if(keypadState == LOW && keypadPin[x] == pin[y]){
        int currKey = y + 1;
        inputKey(currKey); //push current inputted key onto the stack
        flashLED(0,255,0,150); //flash green to indicate key is pressed
        printStk(); //print the stack
      }
    }
  }
  delay(250);

  if(codeEnteredCorrectly() && command == DISARM){
      disarm(); //disarm the warning
      resetKeyInput();
  }
  else if(codeEnteredCorrectly() && command == DELAY){
    delayArm();
    resetKeyInput();
   }
   else if(fourDigitsEntered() && !codeEnteredCorrectly()){
    //flash long red to indicate unsuccessfull password input
    flashLED(255,0,0,500);
    setColor(255,255,0); //set led back to yellow to indicate warning is still active
    //setColor(currRGB[0], currRGB[1], currRGB[2]);
    resetKeyInput();
   }
 }
 
 //delay for specified time
 //allows use to leave their house without setting off the alarm
 void delayArm(){
   int i = 0;
      while(i < delayAmount){
        delay(500); //delay .5 seconds
        setColor(255,0,0); //change color to red
        delay(500); //delay .5 seconds
        setColor(0,0,255); //change color to blue
        i++;
        Serial.print("Delary Arm: ");
        Serial.println(i);
      }
 }
 
 void disarm(){
    //flash long green to indicate successfull password input to client
    flashLED(0,255,0,500);
    warningActive = 0;
    setColor(0,0,255); //set led back to blue
    resetKeyInput();
 }
 
 void resetKeyInput(){
   resetStk();
 }
 
 int codeEnteredCorrectly(){
   return stkMatchesSystemCode();
 }
 
 int fourDigitsEntered(){
   if(stkIsFull()){
     return 1;
   }
   return 0;
 }
 
 int stkMatchesSystemCode(){
   int correct = 0;
   
   for(int i=0; i<4; i++){
     if(stack[i] == systemCode[i]){ //check that contents in stack are the same as the system code
       correct++;
     }
   }
   if(correct == 4){
     return 1;
   }
   else{
     return 0;
   }
 }
 
 void inputKey(int key){
     push(key);
 }
 
 void printStk(){
   int i;
   for(i=0; i<4; i++){
     Serial.print("[");
     Serial.print(stack[i]);
     Serial.print("]");
   }
   Serial.println("");
 }
 
 void push(int val){
   if(stkIsFull()){
     resetStk();
   }
   top++;
   stack[top] = val;
 }
 
 int stkIsFull(){
   if(top >= 3){
     return 1;
   }
   return 0;
 }
 
 void resetStk(){
   int i;
   for(i=0; i<4; i++){
     stack[i] = 0;
   }
   top = -1;
 }
 
 int pop(){
   int val = stack[top];
   top--;
   return val;
 }
