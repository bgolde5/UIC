#include <LiquidCrystal.h>
#include <Wire.h>

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

int fsrAnalogPin = 0; // FSR is connected to analog 0
int LEDpin = 10;      // connect Red LED to pin 11 (PWM pin)
int fsrReading;      // the analog reading from the FSR resistor divider
int LEDbrightness;
int alexArduino = 0;


void setup() {
  Serial.begin(9600); // We'll send debugging information via the Serial monitor
  pinMode(LEDpin, OUTPUT);
  Wire.begin(); // join i2c bus (address optional for master)
  
  Wire.begin(5);                // join i2c bus with address #5
  Wire.onReceive(receiveEvent); // register event
  
  // set up the LCD's number of columns and rows: 
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print("Alex's Arduino");
}

byte x = 0;

void loop() {
  
  //force sensing resisitor
  fsrReading = analogRead(fsrAnalogPin);
  //Serial.print("Analog reading = ");
  //Serial.println(fsrReading);
  
  //transmit to arduino via pin 4
  Wire.beginTransmission(4); // transmit to device #4
  Wire.write("Brad's Analog Reading: ");        // sends five bytes
  Wire.write(fsrReading);  //sends one byte
  Wire.endTransmission();    // stop transmitting

  delay(500);

  //led
  LEDbrightness = map(alexArduino, 0, 1023, 0, 255);
  Serial.println(alexArduino);
  // LED gets brighter the harder you press
  analogWrite(LEDpin, LEDbrightness);
  
  //lcd display
  // set the cursor to column 0, line 1
  lcd.setCursor(0, 1);
  // print force sensing resistor values
  lcd.print(alexArduino);
 
  delay(100);
  
}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int howMany)
{
  while(1 < Wire.available()) // loop through all but the last
  {
    char c = Wire.read(); // receive byte as a character
    Serial.print(c);         // print the character
  }
  int x = Wire.read();    // receive byte as an integer
  alexArduino = x;
  Serial.println(x);         // print the integer
}
