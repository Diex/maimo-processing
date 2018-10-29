/**
 * Mirror 
 * by Daniel Shiffman.  
 *
 * Each pixel from the video source is drawn as a rectangle with rotation based on brightness.   
 */ 
 
import processing.video.*;
import java.util.Date;

Capture video;

boolean showVideo = false;
PImage foto;

PImage[] fotos;
int cols = 5;
int rows = 5;
int actual = 0;

void setup() {
  size(640, 480);
  frameRate(30);
  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  video = new Capture(this, width, height);
  
  // Start capturing the images from the camera
  video.start();  
  
   foto = new PImage(video.width, video.height);
   
   fotos = new PImage[cols * rows];
   
  background(0);
}


void draw() { 
  // funcionamiento de la camara
  if (video.available()) {
    video.read();
    video.loadPixels();
   }
   
   //image(foto, 0,0, width/cols, height/rows);
   
   for(int x = 0; x < cols; x++){
     for(int y = 0; y < rows; y++){
       int cual = x + y * cols;
       if(fotos[cual] == null) continue;
       image(fotos[cual], x * width/cols, y * height/rows, width/cols, height/rows);
     }
   }
   
   if(showVideo) image(video, 0, 0);
}

void keyPressed(){
  
  if(key == ' '){
    foto = video.copy();
    Date fecha = new Date();
    String name = ""+ fecha.getTime();
    foto.save( name+".jpg");
    
    fotos[actual] = video.copy();
    actual = (actual + 1) % (rows * cols);
    
  }
}