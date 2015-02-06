/*
 *  Switch and 2 LED test program
 */
 
int led1Pin = 12;               // LED #1 is connected to pin 12
int led2Pin = 11;               // LED #2 is connected to pin 11
int led3Pin = 10;               // LED #2 is connected to pin 10
int switch1Pin = 2;              // switch is connected to pin 2
int switch2Pin = 3;              // switch is connected to pin 3
int val1;                        // variable for reading pin 2 status
int val2;                        // variable for reading pin 3 status
//int decrement = 1;                  // variable for decrementing the 3 bit count
//int increment = 1;                  // variable for incrementing the 3 bit count
int bitCount = 0;                  // variable for storing the bit count up to the value of 3


void setup() {
  Serial.begin(9600);   // set up Serial library at 9600 bps
  pinMode(switch1Pin, INPUT);    // Set switch1 pin as input
  pinMode(switch2Pin, INPUT);    // Set switch2 pin as input
  pinMode(led1Pin, OUTPUT);     // Set the LED #1 pin as output
  pinMode(led2Pin, OUTPUT);     // Set the LED #2 pin as output
  pinMode(led3Pin, OUTPUT);      // Set the LED #3 pin as output
}//end setup

void loop(){
  
  
  val1 = digitalRead(switch1Pin);    // read input value from switch 1 and store it in val1
  val2 = digitalRead(switch2Pin);    // read input value from switch 2 and store it in val2
  Serial.print("bitCount: ");
  Serial.println(bitCount);    // Read the pin and display the value of switch 1
  //Serial.println(val2);    // Read the pin and display the value of swtich 2
  delay(150);
  
  if (val1 == HIGH && bitCount < 7) {
    bitCount++;
  }
  if (val2 == HIGH && bitCount > 0) {
    bitCount--;
  }
  if (bitCount == 0) { //binary value is 000
    digitalWrite(led1Pin, LOW); //0
    digitalWrite(led2Pin, LOW); //0
    digitalWrite(led3Pin, LOW); //0
  }
  if (bitCount == 1) { //binary value is 001
    digitalWrite(led1Pin, HIGH); //1
    digitalWrite(led2Pin, LOW); //0
    digitalWrite(led3Pin, LOW); //0
  }
  if (bitCount == 2) { //binary value is 010
    digitalWrite(led1Pin, LOW); //0
    digitalWrite(led2Pin, HIGH); //1
    digitalWrite(led3Pin, LOW); //0
  }
  if (bitCount == 3) { //binary value is 011
    digitalWrite(led1Pin, HIGH); //1
    digitalWrite(led2Pin, HIGH); //1
    digitalWrite(led3Pin, LOW); //0
  }
  if (bitCount == 4) { //binary value is 100
    digitalWrite(led1Pin, LOW); //0
    digitalWrite(led2Pin, LOW); //0
    digitalWrite(led3Pin, HIGH); //1
  }
  if (bitCount == 5) { //binary value is 101
    digitalWrite(led1Pin, HIGH); //1
    digitalWrite(led2Pin, LOW); //0
    digitalWrite(led3Pin, HIGH); //1
  }
  if (bitCount == 6) { //binary value is 110
    digitalWrite (led1Pin, LOW); //0
    digitalWrite (led2Pin, HIGH); //1
    digitalWrite (led3Pin, HIGH); //1
  }
  if (bitCount == 7) { //binary value is 111
    digitalWrite (led1Pin, HIGH); //1
    digitalWrite (led2Pin, HIGH); //1
    digitalWrite (led3Pin, HIGH); //1
  }
}//end loop
