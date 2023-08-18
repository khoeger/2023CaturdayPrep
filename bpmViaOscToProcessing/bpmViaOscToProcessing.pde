
/*
 Testing osc processing connection - send bpm from Max to Processing :)
 
 cats see
 - black/white, blue, yellow
 - Less saturation / more grey
 - more movement, nearsighted
 - see 100 frames per second
 
 // Steps
 - Randomly put color (cat inspired) & circle at random loc
 - Put the above there on trigger from Max
 - Put the above or square equivalent on trigger from Max
 
 
 // Helpful links
 - https://forum.processing.org/two/discussion/11063/trying-to-communicate-with-max-osc-processing.html
 - https://sojamo.de/libraries/oscp5/reference/index.html
 - https://opensoundcontrol.stanford.edu/spec-1_0.html
 */



/* OSC Communication Libraries */
import oscP5.*;
import netP5.*;

/* Initialize OSC Objects */
OscP5 oscP5;
NetAddress myRemoteLocation;

/* Variables */
float bpm;
float diff;
int shapeFloat;
boolean drawNow;
int drawStartTime;
String startTimestamp;

/* Initialize Shape Object */
ShapeObject shapeA;

void setup() {

  /* Display setup */
  background(0);
  pixelDensity(1); 
  //size( 950, 1000);
  fullScreen();
  frameRate(100);

  /* Basic Shape Mode*/
  ellipseMode(CENTER);
  rectMode(CENTER);

  /* Colors */
  colorMode(HSB, 360, 100, 100, 1.0);

  /* Start OSC Connection*/
  initOsc();

  /* Initalize Variables */
  bpm = 0;
  diff = 100000;
  shapeFloat = 0;
  drawNow = false;
  drawStartTime = 40000;
  startTimestamp = str(year())+str(month())+str(day())+str(hour())+str(minute());
}

void draw() {

  //if ( millis() - drawStartTime < 30500 ) {
  if (drawNow == true) {

    drawNow = !drawNow;

    //saveFrame("animations/dotDemo/"+startTimestamp+"/#####.png");
    //} else {
    //  saveFrame("animations/dotDemo/"+startTimestamp+"/#####.png");
    //}

    shapeA.display();
  }
//}
}

void initOsc() {
  oscP5 = new OscP5(this, 12000); // Razer
  myRemoteLocation = new NetAddress("10.0.0.12", 8080); // Razer

  //oscP5 = new OscP5("10.0.0.12", 12000); // home network
  // oscP5 = new OscP5("192.168.64.189", 12000); // phone
  //oscP5 = new OscP5("169.254.226.33", 12000); //  ethernet

  //myRemoteLocation = new NetAddress("192.68.64.52", 8080); // phone
  //myRemoteLocation = new NetAddress("10.0.0.7", 8080); // home network
  //myRemoteLocation = new NetAddress("169.254.9.77", 8080); // ethernet
}


void mousePressed() {
  /* Start/Stop drawing on click & send message to control sounds */
  
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/start draw shapes");
  //myMessage.add(123); /* add an int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);

  drawStartTime = millis();
  background(240, 0, 0, 1); // change background black - for white, change third entry 100
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  
  /* Parse incoming message*/
  shapeFloat = int(theOscMessage.get(0).floatValue());
  diff = theOscMessage.get(1).floatValue();
  
  /* Message Triggers following changes */
  drawNow = !drawNow;
  shapeA = new ShapeObject( shapeFloat, diff);
  println(shapeFloat,diff);
}

class ShapeObject {
  /* Shape's internal variables */
  int shapeF ;
  String shapeString;
  int rad;
  float x, y;
  float w, h;
  int hue, saturation, brightness;
  float alpha;

  /*Construct shape*/
  ShapeObject(int shapeFloat_, float diff_) {
    /* Set variables */
    shapeF = shapeFloat_;
    hue = int(random(50, 240));        // yellow to blue
    saturation = int(random(10, 75));  // not too saturated
    brightness = int(random(25, 75));  // not to bright or dark
    // Sound 1 / Pic 1
    if (shapeF == 1) {
      rad = int(map(diff_, 3500, 275, 200, 5));
      alpha = (map(rad, 5, 200, 0.9, 0.1));
    } // Sound 2 / Pic 2 
    else if (shapeF == 2) {
      rad = int(map(diff_, 700, 50, 200, 5));
    } else {
      rad = 500;
    }
    alpha = (map(rad, 5, 200, 0.9, 0.1));
  }

  void display() {
    // Draw shape
    fill( hue, saturation, brightness, alpha);
    noStroke();
    // Sound 1 / Pic 1
    if (shapeF == 1) {
      rect( random(100, width-100), random(100, height-100), rad, rad);
    } // Sound 2 / Pic 2 
    else if (shapeF == 2) {
      ellipse( random(100, width-100), random(100, height-100), rad, rad);
    }
  }
}
