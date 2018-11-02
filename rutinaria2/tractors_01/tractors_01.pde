import twitter4j.conf.*; 
import twitter4j.api.*; 
import twitter4j.*; 
import twitter4j.util.*;


import org.gicentre.utils.gui.HelpScreen;
import org.gicentre.utils.gui.Tooltip;          
import org.gicentre.utils.spatial.Direction;    // For tooltip anchor direction.
import org.gicentre.utils.stat.*;    // For chart classes.


// para cada trending topic hay un tracto que lo muestra en pantalla
ArrayList<Tractor> tractors;


void setup(){
size(1200, 600, P3D);
  
}

void draw(){
  
pushMatrix();
  translate(width/2, height/2);
  PVector center = new PVector(0,0);
  float angle = TWO_PI/5.0;
  float radius = 200;
  
  beginShape(CLOSE);
  noFill();
  stroke(255,0,0);
  float alpha = frameCount*0.0001;
  for(int i = 0; i < 5; i++){
    PVector vertex = new PVector(center.x + radius * cos(alpha), center.y + radius * sin(alpha));
    vertex(vertex.x, vertex.y);
    tractors.get(i).position.x = vertex.x;
    tractors.get(i).position.y = vertex.y;
    alpha += angle;
  }
  endShape();
  fill(255,0,0);
  for (int tractor = 0; tractor < tractors.size(); tractor++){
    tractors.get(tractor).render();
  
  }
  popMatrix();
  

}
