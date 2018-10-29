
import processing.video.*;

Movie idle;
Movie intro;
Movie outro;
Movie question;
Movie current;

String[] filenames;

final int IDLE = 0;
final int PLAYING = 1;

int state = IDLE;
int questionLoop = 1;

void setup() {
  //size(1280, 720);
  size(640, 360);
  idle = new Movie(this, "01_ESPERA_v03.mp4");
  idle.loop();

  intro = new Movie(this, "02_INICIO_v06.mp4") {
    @ Override public void eosEvent() {
      super.eosEvent();
      introEnd();
    }
  };

  outro = new Movie(this, "04_SALE_v04.mp4") {
    @ Override public void eosEvent() {
      super.eosEvent();
      outroEnd();
    }
  };

  current = idle;

  // Using just the path of this sketch to demonstrate,
  // but you can list any directory you like.
  String path = sketchPath() + "/data/03_PREGUNTAS";

  println("Listing all filenames in a directory: ");
  filenames = listFileNames(path);
  printArray(filenames);
}

void draw() {
  image(current, 0, 0, width, height);
}

void keyPressed() {
  if (state == IDLE) {
    state = PLAYING;
    loadNewQuestion();
    idle.stop();
    intro.play();
    current = intro;    
  }
}


void loadNewQuestion() { 
  questionLoop = 1;
  String questionFile = filenames[(int)random(filenames.length)];
  println("Loading: "+questionFile);

  question = new Movie(this, "03_PREGUNTAS/"+questionFile) { // cargo la pregunta...
    @ Override public void eosEvent() {
      super.eosEvent();
      questionEnd();
    }
  };
}

void movieEvent(Movie m) {
  m.read();
}


void introEnd() {
  println("intro end");
  question.play();
  current = question;  
}


void questionEnd() {
  if (questionLoop == 0) {
    outro.play();
    current = outro;    
  } else {
    questionLoop--;
    question.jump(0);
    question.play();
  }
}

void outroEnd() {
  println("outro end");
  resetVideos();
  idle.play();
  current = idle;
  state = IDLE;
}


void resetVideos(){
  intro.jump(0);
  intro.stop();
  outro.jump(0);
  outro.stop();
  
  idle.jump(0);
  idle.stop();
}
// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

// Function to get a list of all files in a directory and all subdirectories
ArrayList<File> listFilesRecursive(String dir) {
  ArrayList<File> fileList = new ArrayList<File>(); 
  recurseDir(fileList, dir);
  return fileList;
}

// Recursive function to traverse subdirectories
void recurseDir(ArrayList<File> a, String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    // If you want to include directories in the list
    a.add(file);  
    File[] subfiles = file.listFiles();
    for (int i = 0; i < subfiles.length; i++) {
      // Call this function on all files in this directory
      recurseDir(a, subfiles[i].getAbsolutePath());
    }
  } else {
    a.add(file);
  }
}
