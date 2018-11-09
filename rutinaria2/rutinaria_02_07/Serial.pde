// Write data to the serial port according to the mouseX value

import processing.serial.*;
 
Serial port;                      // Create object from Serial class
Serial port1;

float mx = 0.0;

void setupSerial(){
   port = new Serial(this, "COM3", 115200); 
}

void updateMotor(int motor, float load, float direction){

  String command = "";
  command += motor+":";
  int speed = int (direction * map(load, 0.0,1.0, 50, 100));
  command += speed;
  println(command);
  
  port.write(motor+":"+ (int) speed +'\n');                        // Write the angle to the serial port
}

void closeConnection(){
  for(int i = 1; i<6; i++){
  port.write(i+":"+0+'\n');                        // Write the angle to the serial port
  }
}
