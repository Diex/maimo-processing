OPC opc;

void setup()
{
  size(340, 300);
  numLeds = width;
  opc = new OPC(this, "127.0.0.1", 7890);
  // Set up your LED mapping here
  for(int out = 0; out < 6; out++){
   opc.ledStrip(out*64, 64, 64 * out + 32, height/2, 1, 0, false);
  }
  
}

int pos = 0;
int numLeds;
void draw()
{
  background(0);
  stroke(255);  
  strokeWeight(1);
  
  pos = int (frameCount *2 ) % width;
  if(mousePressed) pos = mouseX;
  
  drawFlare(pos);


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
