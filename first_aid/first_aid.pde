import processing.serial.*;
import processing.sound.*;
import ddf.minim.*;

Minim minim;
AudioPlayer allBetter, sadAgain, better1, better2, better3;

int emote, emoteLimit, tStart, tStop;
boolean isSad, pressButton, flipSwitch, joyUp, joyDown, joyLeft, joyRight;
PImage face1, face2, face3, face4;

SoundFile file;

Serial myPort;  // The serial port

void setup() {
  // List all the available serial ports
  //printArray(Serial.list());
  // Open the port you are using at the rate you want:
  size(800, 480);
  
  myPort = new Serial(this, Serial.list()[11], 115200);
  
  face1 = loadImage("face1.png");
  face2 = loadImage("face2.png");
  face3 = loadImage("face3.png");
  face4 = loadImage("face4.png");
  
  minim = new Minim(this);
  allBetter = minim.loadFile("AllBetter.wav");
  sadAgain = minim.loadFile("SadAgain.wav");
  better1 = minim.loadFile("Better1.wav");
  better2 = minim.loadFile("Better2.wav");
  better3 = minim.loadFile("Better3.wav");
  
  emote = 3;
  emoteLimit = 3;
  //tStart = millis();
}

void beSad() {
  //Reset all values
  isSad = true;
  pressButton = false;
  flipSwitch = false;
  joyUp = false;
  joyDown = false;
  joyLeft = false;
  joyRight = false;
  emote = 0;
  
  //Create random seed that will establish new expected input
  float button = random(0, 1);
  float flip = random(0, 1);
  float axis = random(0, 1);
  float y = random(0, 1);
  float x = random(0, 1);
  
  //Setting button input
  if (button >= 0.5) {
    pressButton = true;
  }
  
  //Setting switch input
  if (flip >= 0.5) {
    flipSwitch = true;
  }
  
  //Setting joystick axis
  if (axis >= 0.5) {
    //Setting joystick y input
    if (y >= 0.5) {
      joyDown = true;
    } else {
      joyUp = true;
    }
  } else {
    //Setting joystick x input
    if (x >= 0.5) {
      joyRight = true;
    } else {
      joyLeft = true;
    }
  }
  println("I'm sad again.");
}

//void beHappy() {

//  //println("Finally, I am happy!");
//}

void displayFace() {
  if (emote == emoteLimit) {
    image(face1, 0, 0);
    isSad = false;
  }
  
  if (emote == (emoteLimit - 1)) {
    image(face2, 0, 0);
  }
  
  if (emote == (emoteLimit - 2)) {
    image(face3, 0, 0);
  }
  
  if (emote == (emoteLimit - 3)) {
    image(face4, 0, 0);
  }
}

void playSound() {
  if (emote == emoteLimit) {
    allBetter.play();
    better3.rewind();
  }
  
  if (emote == (emoteLimit - 1)) {
    better3.play();
    better2.rewind();
  }
  
  if (emote == (emoteLimit - 2)) {
    better2.play();
    better1.rewind();
  }
  
  if (emote == (emoteLimit - 3)) {
    better1.play();
  }
}

void draw() {

  while (myPort.available() > 0) {
    String inMsg = myPort.readString();
    //println(inMsg);

    String[] input = split(inMsg, ",");
    //printArray(input);

    displayFace();
    
    if (isSad) {
      tStart = millis();
    }
  
    if (emote == emoteLimit) {
      if (millis() - tStart > 5000) {
        beSad();
        println(pressButton, flipSwitch, joyUp, joyDown, joyLeft, joyRight);
        emoteLimit = int(pressButton) + int(flipSwitch) + int(joyUp) + int(joyDown) + int(joyLeft) + int(joyRight);
        allBetter.rewind();
        sadAgain.play();
        sadAgain.rewind();
      }
    }
    
    if (pressButton) {
      if (int(input[0]) < 100) {
        emote += 1;
        pressButton = false;
        playSound();
        println("Feeling better... button");
      }
    }
    
    if (flipSwitch) {
      if (int(input[1]) > 3000) {
        emote += 1;
        flipSwitch = false;
        playSound();
        println("Feeling better... switch");
      }
    }
    
    if (joyUp) {
      if (int(input[2]) < 500) {
        emote += 1;
        joyUp = false;
        playSound();
        println("Feeling better... jup");
      }
    }
    
    if (joyDown) {
      if (int(input[2]) > 3000) {
        emote += 1;
        joyDown = false;
        playSound();
        println("Feeling better... jdown");
      }
    }
    
    if (joyLeft) {
      if (int(input[3]) < 500) {
        emote += 1;
        joyLeft = false;
        playSound();
        println("Feeling better... jleft");
      }
    }
    
    if (joyRight) {
      if (int(input[3]) > 3000) {
        emote += 1;
        joyRight = false;
        playSound();
        println("Feeling better... jright");
      }
    }
  }
}
