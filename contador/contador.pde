int count = 0;
boolean limite = false;

void setup(){
  size(800,600);
}

void draw(){
  println("Cuenta: " + count);
  //verArduino();
}


//void verArduino(){
//  if(arduino.valor > 0){
//    sumaUno();
//  }else{
//    reset();
//  }
//}

//void keyPressed(){
  void sumaUno(){
  if(limite) return;  
  if(key == ' '){
    limite = true;
    count++;
  }
}

//void keyReleased(){
  void reset(){
  limite = false;
}
  