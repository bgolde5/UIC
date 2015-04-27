void setup() {
  // initialize the serial communication:
  Serial.begin(9600);
}

void loop() {
  // send the value of analog input 0:
  int potentiometer = analogRead(A0);
  int forceSensitiveResistor = analogRead(A1);
  //Serial.print("Force Sensitive Resistor: ");
  Serial.println(forceSensitiveResistor);
  //Serial.print("Potentiometer: ");
  Serial.println(potentiometer);
  // wait a bit for the analog-to-digital converter 
  // to stabilize after the last reading:
  delay(2);
}
