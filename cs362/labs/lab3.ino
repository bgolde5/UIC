/*

  First line display static text
  Second line scrolls a quote
  
 Reference: http://arduino.cc/en/Tutorial/LiquidCrystal
 https://nishantarora.in/tutorial-arduino-16x2-lcd-how-to-scroll-only-one-line-at-a-time-while-keeping-the-other-constant.naml
 
 The circuit:
 * LCD RS pin to digital pin 12
 * LCD Enable pin to digital pin 11
 * LCD D4 pin to digital pin 5
 * LCD D5 pin to digital pin 4
 * LCD D6 pin to digital pin 3
 * LCD D7 pin to digital pin 2
 * LCD R/W pin to ground
 * 10K resistor:
 * ends to +5V and ground
 * wiper to LCD VO pin (pin 3)
*/

// include the library
#include <LiquidCrystal.h>

// init the lcd display according to the circuit
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

//set up screen width
int screenWidth = 16;
int screenHeight = 2;

// the two lines
// name = static text
String name = "Bradley Golden";
// quote = scrolling text
String quote = "First they ignore you, then they laugh at you, then they fight you, then you win.";

// flags
int stringStart, stringStop = 0;
int scrollCursor = screenWidth;

void setup() {
  lcd.begin(screenWidth,screenHeight);
}

void loop() {
  //set static text
  lcd.setCursor(0, 0);
  lcd.print(name);
  
  //set scrolling text
  lcd.setCursor(scrollCursor, 1);
  lcd.print(quote.substring(stringStart,stringStop));
  delay(200);
  lcd.clear();
  
  if(stringStart == 0 && scrollCursor > 0){
    scrollCursor--;
    stringStop++;
    
  } else if (stringStart == stringStop){
    stringStart = stringStop = 0;
    scrollCursor = screenWidth;
    
  } else if (stringStop == quote.length() && scrollCursor == 0) {
    stringStart++;
    
  } else {
    stringStart++;
    stringStop++;
  }
}
