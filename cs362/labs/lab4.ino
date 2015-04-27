/******************************
      INITIALIZE LCD
******************************/
// include the library
#include <LiquidCrystal.h>

// initialize the lcd display according to the circuit
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

//set up screen width
int screenWidth = 16;
int screenHeight = 2;

// the two lines
// name = static text
String lcdStr = "Starting...";

/******************************
  INITIALIZE PHOTO RESISTOR
******************************/
//define a pin for Photo resistor
int lightPin = A0;  

//define light level
int lightLevel = 0;    

/******************************
         VOID SETUP
******************************/
void setup()
{
    lcd.begin(screenWidth,screenHeight);
    Serial.begin(9600);  //Begin serial communcation
}
/******************************
         VOID LOOP
******************************/
void loop()
{   
   //read in current light level
   lightLevel = analogRead(lightPin);
   
   //print light level to serial
   Serial.println(lightLevel); //Write the value of the photoresistor to the serial monitor.
   delay(100); //short delay for faster response to light.
   
   if(lightLevel > 800)
     lcdStr = "Dark";
   else if(lightLevel <= 800 && lightLevel > 550)
     lcdStr = "Partially Dark";
   else if(lightLevel <= 550 && lightLevel > 350)
     lcdStr = "Medium";
   else if(lightLevel <= 350 && lightLevel > 200)
     lcdStr = "Partially Lit";
   else
     lcdStr = "Fully Lit";
   
  //set static on lcd text
  lcd.setCursor(0, 0);
  lcd.print(lcdStr);
  delay(500);
  lcd.clear();
}
  
  
