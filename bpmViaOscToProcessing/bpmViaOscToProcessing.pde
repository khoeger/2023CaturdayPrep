
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

/* Images */
PImage imgSandCat, imgOcelot,
  imgCaracal, imgCheetah,
  imgCloudedLeopard, imgPampasCat,
  imgBobcat, imgIberianLynx,
  imgSiberianTiger, imgCougar;
String[] imageStringArray = {
  "1_ArabianSandCat_FelisMargarita.png",
  "2_Ocelot_LeopardusPardalis.png",
  "3_Caracal_CaracalCaracal.png",
  "4_Cheetah_AcinonyxJubatus.png",
  "5_CloudedLeopard_NeofelisNebulosa.png",
  "6_PampasCat_LeopardusColocolo.png",
  "7_Bobcat_LynxRufus.png",
  "8_IberianLynx_LynxPardinus.png",
  "9_SiberianTiger_PantheraTigris.png",
  "10_Cougar_PumaConcolar.png"
};
ArrayList<PImage> imageArray;
ArrayList<HashMap> hashMapArray;
String imageStringBase = "inputImages/";
String imageType = ".png";
String currentHashName;
int currentIndex;

color baseColor;
float baseProportion = 0.0175;
float proportion = baseProportion;

float scalar = 1;
int seed = 20230819;

int[] img1Pixels, img2Pixels;

PFont myFont;

int maxShapeWidth = 276;
int maxShapeHeight = maxShapeWidth + int(random(10));
int shapeWidthIncrement = 1;
int shapeHeightIncrement = shapeWidthIncrement;

int borderSpace = 125;

int x, y, loc;
float r, g, b, a;
int maxFrames;

int alphaValue = 0;
int spotsDrawn = 0;
int shapeWidth = maxShapeWidth;
int shapeHeight = maxShapeHeight;

String[] shapeOptions = {
  "circle", // 0
  //"ellipse", // 1
  //"ellipseRotate", // 2
  ////"imageIn", // 3
  ////"imageInRotate", // 4
  ////"imageInRotateFlip", // 5 BROKEN?
  //"line", // 6
  "lineRotate", // 7
  //"lineWeight", // 8
  "lineWeightRotate", // 9
  //"rect", // 10
  "rectRotate", // 11
  //"triangle", // 12
  "triangleRotate", // 13
  //"square", // 14
  "squareRotate", //15
  "word"
};
String shapeType;// = shapeOptions[int(random(shapeOptions.length))];//15];


void setup() {

  /* Display setup */
  background(0);
  pixelDensity(1);
  //size( 950, 1000);
  fullScreen();
  frameRate(100);
  random(seed);

  /* Basic Shape Mode*/
  ellipseMode(CENTER);
  rectMode(CENTER);

  /* Colors */
  //colorMode(HSB, 360, 100, 100, 1.0);
  baseColor = color(0);//color(240, 0, 0, 1);
  /* Start OSC Connection*/
  initOsc();

  /* Initalize Variables */
  bpm = 0;
  diff = 1000;
  shapeFloat = 1;
  drawNow = false;
  drawStartTime = 40000;
  startTimestamp = str(year())+str(month())+str(day())+str(hour())+str(minute());

  imageArray = new ArrayList<PImage>();
  //hashMapArray = new ArrayList< HashMap >();


  imgSandCat = loadImage( imageStringBase+imageStringArray[0] );
  imgSandCat.resize( 0,  height  - 2 * borderSpace ); // wider than tall
  imgSandCat.loadPixels();

  imgOcelot = loadImage( imageStringBase+imageStringArray[1] );
  imgOcelot.resize( 0,  height  - 2 * borderSpace ); // wider than tall
  imgOcelot.loadPixels();

  shapeA = new ShapeObject( shapeFloat, diff);
}

void draw() {

  //if ( millis() - drawStartTime < 30500 ) {
  if (drawNow == true) {

    drawNow = !drawNow;

    //saveFrame("animations/dotDemo/"+startTimestamp+"/#####.png");
    //} else {
    //  saveFrame("animations/dotDemo/"+startTimestamp+"/#####.png");
    //}
    shapeA.update( shapeFloat, diff);
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
  background(baseColor); // change background black - for white, change third entry 100
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {

  /* Parse incoming message*/
  shapeFloat = int(theOscMessage.get(0).floatValue());
  diff = theOscMessage.get(1).floatValue();

  /* Message Triggers following changes */
  drawNow = !drawNow;
  //shapeA.update( shapeFloat, diff);
  //println(shapeFloat,diff);
}

class ShapeObject {
  /* Shape's internal variables */
  int shapeF ;
  String shapeString;
  int rad;
  int x, y;
  //int hue, saturation, brightness;
  float r, g, b;
  float alpha;
  int loc;
  PImage img;

  /*Construct shape*/
  ShapeObject(int shapeFloat_, float diff_) {
    /* Set variables */
    //shapeF = shapeFloat_;
    //hue = int(random(50, 240));        // yellow to blue
    //saturation = int(random(10, 75));  // not too saturated
    //brightness = int(random(25, 75));  // not to bright or dark
    //r= 0;
    //g= random(10, 225);
    //b= random(10, 225);
    update(shapeFloat_, diff_);
    //// Sound 1 / Pic 1
    //if (shapeF == 1) {
    //  rad = int(map(diff_, 3500, 275, 200, 5));
    //  alpha = (map(rad, 5, 200, 0.9, 0.1));
    //} // Sound 2 / Pic 2
    //else if (shapeF == 2) {
    //  rad = int(map(diff_, 700, 50, 200, 5));
    //} else {
    //  rad = 500;
    //}
    //alpha = (map(rad, 5, 200, 0.9, 0.1));
    //x = int(random(borderSpace, width-borderSpace));
    //y = int(random(borderSpace, height-borderSpace));
  }

  void display() {
    // Draw shape
    push();
    translate(borderSpace, borderSpace);
    fill( r, g, b, alpha);
    noStroke();
    translate(x,y);
    // SandCat
    if (shapeF == 1) {
      rect(0, 0, rad, rad);
    } // Ocelot
    else if (shapeF == 2) {
      ellipse( 0, 0, rad, rad);
    }
    pop();
  }

  void update( int shapeFloat_, float diff_) {

    shapeF = shapeFloat_;

    
    if (shapeF == 1) { // Sand Cat
      img = imgSandCat;
      rad = int(map(diff_, 3500, 275, 200, 5));
    } // Ocelot
    else if (shapeF == 2) {
      img = imgOcelot;
      rad = int(map(diff_, 700, 50, 200, 5));

    } else {
      
    }


      x = floor(random(img.width));
      y = floor(random(img.height));
      loc = x + y * img.width;

      //rad = int(map(diff_, 3500, 275, 200, 5));
      alpha = (map(rad, 5, 200, 245, 10));
      r = red(img.pixels[loc]);
      g = green(img.pixels[loc]);
      b = blue(img.pixels[loc]);
    //alpha = (map(rad, 5, 200, 0.9, 0.1));



   
  }
}
