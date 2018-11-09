OPC opc;
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;



void setup()
{
  size(350, 300);
  numLeds = 360;
  opc = new OPC(this, "127.0.0.1", 7890);
  // Set up your LED mapping here
  for(int out = 0; out < 6; out++){
   opc.ledStrip(out*64, 64, 64 * out + 32, height/2, 1, 0, false);
  }
  
  opc.ledStrip(384, 30, 64 * 6 + 32, height/2, 1, 0, false);
    oscP5 = new OscP5(this,12000);
  
  myRemoteLocation = new NetAddress("127.0.0.1",12001);
  


}

int pos = 0;
int numLeds;

void draw()
{
  background(0);
  stroke(255);  
  strokeWeight(1);
  
  pos = int (frameCount *16 ) % numLeds;
  if(mousePressed) pos = mouseX;
    
  drawFlare(pos);

     /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/test");
  
  myMessage.add((float) pos/numLeds); /* add an int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);

}

int flareWidth = 20;


void drawFlare(int pos){

  for(int led = 0; led < flareWidth; led++){
      int next = pos + led > numLeds ? flareWidth - led : pos + led ;
      int prev = pos - led < 0 ? numLeds - led + pos : pos - led;
       stroke(255,0,0);
      line(pos, 0, pos,height );
      
      stroke(255, (int) map(led, flareWidth, 0, 0, 255));
      line(prev, 0, prev,height );
      line(next, 0, next,height );
      
      
  }
}
