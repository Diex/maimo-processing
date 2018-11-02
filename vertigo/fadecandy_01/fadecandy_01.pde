OPC opc;

void setup()
{
  size(600, 300);
  opc = new OPC(this, "127.0.0.1", 7890);

  // Set up your LED mapping here
   opc.ledStrip(0, 64, width/2, height/2, width / 70.0, 0, false);
}

int pos = 0;

void draw()
{
  background(0);
  stroke(0);
  //fill(0,10);
  //rect(0,0,width, height);
  
  strokeWeight(10);
  //pos = (pos +5 ) % width;
  pos = mouseX;
  for(int i = 0; i < 100; i++){
    stroke(map(i, 100,0, 0, 255), 130, 200);  
    line(pos-i, 0, pos-i, height);
    line(pos+i, 0, pos+i, height);
  }
  // Draw each frame here
}
