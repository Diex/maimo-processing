import processing.video.*;

/**
 * Edge Detection
 * 
 * Change the default shader to apply a simple, custom edge detection filter.
 * 
 * Press the mouse to switch between the custom and default shader.
 */

PShader edges;  
PImage img;
boolean enabled = true;
Movie video;

void setup() {
  size(1280, 720, P2D);
  video = new Movie(this, "2016-11-02 18-15-51.mov");
  video.loop();
  img = loadImage("leaves.jpg");      
  edges = loadShader("edges.glsl");
}

void draw() {
  if (enabled == true) {
    shader(edges);
  }
if (video.available() == true) {
  video.read();
   image(video, 0, 0);
}

 
}

void movieEvent(Movie m) {
  
}

void mousePressed() {
  enabled = !enabled;
  if (!enabled == true) {
    resetShader();
  }
}