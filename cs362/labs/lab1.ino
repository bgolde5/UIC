/*
  Triple Blink
  Turns on three LED's on and off at differnt times for a period of
  a half of a second.
  
  1/19/2015
  by Bradley Golden
 */


// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin 13 as an output.
  pinMode(13, OUTPUT); //onboard LED
  pinMode(12, OUTPUT);
  pinMode(11, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
  int delayAmount = 500;  //delay for .5 seconds
  digitalWrite(13, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(delayAmount);              // wait for a second
  digitalWrite(13, LOW);    // turn the LED off by making the voltage LOW
  delay(delayAmount);              // wait for a second
  digitalWrite(12, HIGH);
  delay(delayAmount);
  digitalWrite(12, LOW);
  delay(delayAmount);
  digitalWrite(11, HIGH);
  delay(delayAmount);
  digitalWrite(11, LOW);
  delay(delayAmount);
}
