// Write data to the serial port according to the mouseX value

import processing.serial.*;
 
Serial port;                      // Create object from Serial class
Serial port1;

float mx = 0.0;

void setupSerial(){
   port = new Serial(this, "/dev/cu.wchusbserial1410", 115200); 
}

void updateSerial(){
  
  rectMode(CENTER);
  fill(204);    // Set fill color 
  rect(width/2, height/2, width * .80, 25);      // Draw square

  mx = map(mouseX, 0, width, -width * .8 /2, width * .8 /2);                // Keeps marker on the screen
  
  noStroke();
  fill(255);
  rect(width/2, (height/2), width * .8 , 5);  
  fill(204, 102, 0);
  
  rect((width/2) + mx, height/2, 4, 5);               // Draw the position marker
  int angle = int(map(mx, -width * .8 /2, width * .8 /2, 30, 180));  // Scale the value to the range 0-180

  
  print("1:"+angle+'\n');
   //port.write(angle);                        // Write the angle to the serial port
}
