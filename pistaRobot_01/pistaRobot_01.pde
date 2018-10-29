int dia = 1000; //mm
int tapeW = 24;


void setup(){
  size(1020, 1020);  

}

void draw(){
  background(255);
  
  //ellipse(width/2, height/2, dia/2, dia/2);
  fill(0);
  polygon(width/2, height/2, dia/2, 8);
  
  fill(255);
  polygon(width/2, height/2, dia/2 - tapeW, 8);
  
}

void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}