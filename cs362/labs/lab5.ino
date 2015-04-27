#include <Servo.h> 

/*************** servo ********************/
Servo myservo; 
int val;

/*************** tilt sensor ********************/
int tiltState = 0;

/*************** motor ********************/
int motorPin = 3;

void setup() 
{ 
  myservo.attach(9);
  
  //tilt sensor    
  pinMode(7, INPUT);
  
  //motor
  pinMode(motorPin, OUTPUT);
} 
 
void loop() 
{ 
  //servo
  val = analogRead(0);
  val = map(val, 0, 1023, 180, 1);
  myservo.write(val);
  delay(5);
 
  tiltState = digitalRead(7);
  
    if (tiltState == HIGH) // This if statement will prevent the user from entering invalid motor speeds
    {
      analogWrite(motorPin, 50); 
    }
    else {
      analogWrite(motorPin, 0);
    }
}
