
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
PImage img, imgSandCat, imgOcelot,
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
  imageMode(CENTER);

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


  imgCougar = loadImage( imageStringBase+imageStringArray[9] );
  img = imgCougar;
  img.resize( 0, height  / 3 ); // wider than tall
  img.loadPixels();
  //tint(255, 150);
  //image(img, width/2, height/2);

  imgSiberianTiger = loadImage( imageStringBase+imageStringArray[8] );
  img = imgSiberianTiger;
  img.resize( 0, height /3 ); // wider than tall
  img.loadPixels();
  //tint(255, 150);
  //image(img, width/2 + 400, height/2);

  imgCheetah = loadImage( imageStringBase+imageStringArray[3] );
  img = imgCheetah;
  img.resize( 0, height/3 ); // wider than tall
  img.loadPixels();
  //tint(255, 150);
  //image(img, width/2 - 400, height/2);

  imgCaracal = loadImage( imageStringBase+imageStringArray[2] );
  img = imgCaracal;
  img.resize( 0, height/4 ); // wider than tall
  img.loadPixels();
  //tint(255, 150);
  //image(img, width/5-50, 3*height/4-100);

  imgIberianLynx = loadImage( imageStringBase+imageStringArray[7] );
  img = imgIberianLynx;
  img.resize( 0, height/4 ); // wider than tall
  img.loadPixels();
  //push();
  //translate(width/5-100, 2*height/4-100);
  //tint(255, 150);
  //image(img, 0, 0);
  //pop();

  imgSandCat = loadImage( imageStringBase+imageStringArray[0] );
  img = imgSandCat;
  img.resize( 0, height/5 ); // wider than tall
  img.loadPixels();
  //tint(255, 150);
  //push();
  //translate(width/2-165, 1*height/5 + 75 );
  //scale(-1, 1);
  //rotate(PI/30);
  //image(img, 0, 0);
  //pop();

  imgOcelot = loadImage( imageStringBase+imageStringArray[1] );
  img = imgOcelot;
  img.resize( 0, height/3 ); // wider than tall
  img.loadPixels();
  //tint(255, 150);
  //push();
  //translate(6*width/7, 2*height/5+200);
  //scale(-1, 1);
  //image(img, 0, 0);
  //pop();

  imgCloudedLeopard = loadImage( imageStringBase+imageStringArray[4] );
  img = imgCloudedLeopard;
  img.resize( 0, height/3 ); // wider than tall
  img.loadPixels();
  //tint(255, 150);
  //image(img, 4*width/5, 1*height/4);

  imgBobcat = loadImage( imageStringBase+imageStringArray[6] );
  img = imgBobcat;
  img.resize( 0, height/3 ); // wider than tall
  img.loadPixels();
  //tint(255, 150);
  //push();
  //translate(width/2+200, 1*height/5 + 50 );
  //rotate(PI/18);
  //scale(-1, 1);
  //image(img, 0, 0);
  //pop();

  imgPampasCat = loadImage( imageStringBase+imageStringArray[5] );
  img = imgPampasCat;
  img.resize( 0, height  /4 ); // wider than tall
  img.loadPixels();
  //tint(255, 150);
  //push();
  //translate(450, 1*height/4-75);
  //scale(-1, 1);
  //image(img, 0, 0);
  //pop();


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
    if (shapeA.a >0) {
      shapeA.display();
    }
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
  float a;
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

    fill( r, g, b, a);
    noStroke();

    // SandCat
    if (shapeF == 1) {
      push();
      translate(width/2-165, 1*height/5 + 75 );
      translate(-img.width/2, -img.height/2);
      translate(x, y);
      scale(-1, 1);
      rotate(PI/30);
      rect(0, 0, rad, rad);
      pop();
    } // Ocelot
    else if (shapeF == 2) {
      push();
      translate(6*width/7, 2*height/5+200);
      translate(-img.width/2, -img.height/2);
      translate(x, y);
      scale(-1, 1);
      ellipse( 0, 0, rad, rad);
      pop();
    } // Caracal
    else if (shapeF == 3) {
      push();
      translate(width/5-50, 3*height/4-100);
      translate(-img.width/2, -img.height/2);
      translate(x, y);
      ellipse( 0, 0, rad, rad);
      pop();
    }
    // Cheetah
    else if (shapeF == 4) {
      push();
      translate( width/2 - 400, height/2);
      translate(-img.width/2, -img.height/2);
      translate(x, y);
      ellipse( 0, 0, rad, rad);
      pop();
      //image(img, width/2 - 400, height/2);
    }
    // Clouded Leopard
    else if (shapeF == 5) {
      push();
      translate( 4*width/5, 1*height/4);
      translate(-img.width/2, -img.height/2);
      translate(x, y);
      ellipse( 0, 0, rad, rad);
      pop();
    }
    // Pampas Cat
    else if (shapeF == 6) {
      push();
      translate(450, 1*height/4-75);
      translate(-img.width/2, -img.height/2);
      translate(x, y);
      scale(-1, 1);
      ellipse( 0, 0, rad, rad);
      pop();
    }
    // Bobcat
    else if (shapeF == 7) {
      push();
      translate(width/2+200, 1*height/5 + 50 );
      translate(-img.width/2, -img.height/2);
      translate(x, y);
      rotate(PI/18);
      scale(-1, 1);
      ellipse( 0, 0, rad, rad);
      pop();
    }
    // Iberian Lynx
    else if (shapeF == 8) {
      push();
      translate(width/5-100, 2*height/4-100);
      translate(-img.width/2, -img.height/2);
      translate(x, y);
      ellipse( 0, 0, rad, rad);
      pop();
    }
    // Siberian Tiger
    else if (shapeF == 9) {
      push();
      translate( width/2 + 400, height/2);
      translate(-img.width/2, -img.height/2);
      translate(x, y);
      ellipse( 0, 0, rad, rad);
      pop();
    }
    // Cougar
    else if (shapeF == 10) {
      push();
      translate(width/2, height/2);
      translate(-img.width/2, -img.height/2);
      translate(x, y);
      ellipse( 0, 0, rad, rad);
      pop();
    }
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
    } else if (shapeF == 3) {
      img = imgCaracal;
      rad = int(map(diff_, 700, 50, 200, 5));
    } else if (shapeF == 4) {
      img = imgCheetah;
      rad = int(map(diff_, 700, 50, 200, 5));
    } else if (shapeF == 5) {
      img = imgCloudedLeopard;
      rad = int(map(diff_, 700, 50, 200, 5));
    } else if (shapeF == 6) {
      img = imgPampasCat;
      rad = int(map(diff_, 700, 50, 200, 5));
    } else if (shapeF == 7) {
      img = imgBobcat;
      rad = int(map(diff_, 700, 50, 200, 5));
    } else if (shapeF == 8) {
      img = imgIberianLynx;
      rad = int(map(diff_, 700, 50, 200, 5));
    } else if (shapeF == 9) {
      img = imgSiberianTiger;
      rad = int(map(diff_, 700, 50, 200, 5));
    } else if (shapeF == 10) {
      img = imgCougar;
      rad = int(map(diff_, 700, 50, 200, 5));
    }


    x = floor(random(img.width));
    y = floor(random(img.height));
    loc = x + y * img.width;

    a = alpha(img.pixels[loc]);
    if (a > 0) {
      a = (map(rad, 5, 200, 245, 10));
    }
    r = red(img.pixels[loc]);
    g = green(img.pixels[loc]);
    b = blue(img.pixels[loc]);
  }
}
