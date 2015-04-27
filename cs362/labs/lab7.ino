/*
 
  Demonstrates the use of the 16x2 LCD, a push button, and the
   attachInterrupt() command
 
References:
http://www.arduino.cc/en/Tutorial/LiquidCrystal
http://arduino.cc/en/Tutorial/Button 
http://arduino.cc/en/Reference/attachInterrupt
*/

// include the library code:
#include <LiquidCrystal.h>

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(12, 11, 5, 4, 3, 1);

// initialize interrupt
int buttonPin = 2;
volatile int state = LOW;
volatile int flag = HIGH;

int buttonState = 0;

void setup() {
  
  //interrupt
  pinMode(buttonPin, INPUT);
  attachInterrupt(0, blink, RISING);
  
  // set up the LCD's number of columns and rows: 
  lcd.begin(16, 2);
  // Print a message to the LCD.
  printHelloWorld();
}

void loop() {
  digitalWrite(buttonPin, state);
  printHelloWorld();
  delay(500);
}

void blink()
{
  state = !state;
  testPrint();
}

void testPrint(){
    lcd.clear();  
    lcd.print("Interrupt");
    lcd.setCursor(0,1);
    lcd.print("received!"); 
    delay(1000);
}

void printHelloWorld(){
    lcd.clear();
    lcd.print("Hello World!");
    delay(500);
}
