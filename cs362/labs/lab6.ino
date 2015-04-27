#include <Time.h>
#include <LiquidCrystal.h>

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

char buf[17];
char hourStr[3];
char minStr[3];
char secStr[3];
char daysStr[3];
char monStr[3];
char yearStr[5];
int i;
int index;
time_t t;

void setup() {
  //setTime(12,00,00,01,01,2010);
  Serial.begin(9600);
  delay(1000);
  Serial.print("Enter the date and time (HR:MIN MM/DD/YYYY): "); //i.e. 18:00 01/03/1987 18001012010 - 12:00:00 1 1 2010
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
}

void loop() {
  if (Serial.available() ) {

    delay(100);
    lcd.clear();

    do{
      Serial.readBytesUntil('\n', buf, 17);
    
    
    //Serial.print("Buffer: ");
    //Serial.println(buf);

    index = 0;
    for (i = 0; i < 2; i++) {
      hourStr[i] = buf[index];
      index++;
    }
    index++; //skip ":"
    for (i = 0; i < 2; i++) {
      minStr[i] = buf[index];
      index++;
    }
    /*
    for (i = 0; i < 2; i++) {
      secStr[i] = buf[index];
      index++;
    }*/
    
    index++; //skip " "
    for (i = 0; i < 2; i++) {
      monStr[i] = buf[index];
      index++;
    }
    
    index++; //skip "/"
    for (i = 0; i < 2; i++) {
      daysStr[i] = buf[index];
      index++;
    }
    
    index++; //skip "/"
    for (i = 0; i < 5; i++) {
      yearStr[i] = buf[index];
      index++;
    }
    } while(inputNotCorrect() == 0);
    setTime(atoi(hourStr), atoi(minStr), 0, atoi(daysStr), atoi(monStr), atoi(yearStr));


    /*
    Serial.print("Hour: ");
    Serial.println(hourStr);
    Serial.print("Minutes: ");
    Serial.println(minStr);
    Serial.print("Seconds: ");
    Serial.println(secStr);
    Serial.print("Day: ");
    Serial.println(daysStr);
    Serial.print("Month: ");
    Serial.println(monStr);
    Serial.print("Year: ");
    Serial.println(yearStr);
    */

    //lcd.write(m);
  }
  if (timeStatus() == timeNotSet)
    Serial.print("");
  else {
    lcd.clear();
    t = now();
    lcd.setCursor(0,0);
    lcd.print(makeTimeStr(t));
    delay(100);
    lcd.setCursor(0,1);
    lcd.print(makeDateStr(t));
    digitalClockDisplay();
  }
  delay(1000);
}

int inputNotCorrect(){
    
    if(atoi(hourStr)<0 || atoi(hourStr)>24)
      return 0;
    else if(atoi(minStr)<0 || atoi(minStr)>60)
      return 0;
    else if(atoi(monStr)<1 || atoi(monStr)>12)
      return 0;
    else if(atoi(daysStr)<1 || atoi(daysStr)>31)
      return 0;
    else if(atoi(yearStr)<0 || atoi(yearStr)>2015)
      return 0;
    else
      return 1;
}

String makeTimeStr(time_t t){
  
  String tmpSec = String(second(t),DEC);  
  //force seconds to be two digits
  if(tmpSec.length()<2)
    tmpSec = String("0"+tmpSec);
  
  String tmpHour = String(hour(t),DEC);
  //force hour to be two digits
  if(tmpHour.length()<2)
    tmpHour = String("0"+tmpHour);
  
  String tmpMin = String(minute(t), DEC);
  //force minutes to be two digits
  if(tmpMin.length()<2)
    tmpMin = String("0"+tmpMin);
  
  return String(tmpHour + ":" + tmpMin + ":" + tmpSec + " ");
}
String makeDateStr(time_t t){
    String tmpDay = String(day(t),DEC);
    String tmpYr = String(year(t),DEC);
    String tmpMon = String(month(t),DEC);
    
    return String(tmpMon + "/" + tmpDay + "/" + tmpYr);
}

void digitalClockDisplay() {
  // digital clock display of the time
  Serial.print(hour());
  printDigits(minute());
  printDigits(second());
  Serial.print(" ");
  Serial.print(day());
  Serial.print(" ");
  Serial.print(month());
  Serial.print(" ");
  Serial.print(year());
  Serial.println();
}

void printDigits(int digits) {
  // utility function for digital clock display: prints preceding colon and leading 0
  Serial.print(":");
  if (digits < 10)
    Serial.print('0');
  Serial.print(digits);
}
