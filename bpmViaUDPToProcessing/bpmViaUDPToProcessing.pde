

/*
 Testing osc processing connection - send bpm from Max to Processing :)
 
 cats see
 - black/white, blue, yellow
 - Less saturation / more grey
 - more movement, nearsighted
 - see 100 frames per second
 
 // Helpful links
 - https://forum.processing.org/two/discussion/11063/trying-to-communicate-with-max-osc-processing.html
 - https://sojamo.de/libraries/oscp5/reference/index.html
 - https://opensoundcontrol.stanford.edu/spec-1_0.html
 - http://ubaa.net/shared/processing/udp/udp_class_udp.htm
 
 */




//import oscP5.*;
//import netP5.*;
import hypermedia.net.*; // udp library

//OscP5 oscP5;
//NetAddress myRemoteLocation;

UDP udpReceive, udpSend;

float bpm;

boolean drawNow;
int drawStartTime;

String startTimestamp;

int PORT_HOST = 8082;
int PORT_RECIPIENT = 8080;
String HOST_IP="169.254.226.33";
String RECIPIENT_IP = "169.254.9.77";
int bufferSize = 100;

void setup() {

  background(0);

  size(800, 1000);
  frameRate(100);

  colorMode(HSB, 360, 100, 100, 1.0);

  //initOsc();
  
  udpReceive = new UDP(this, PORT_HOST, HOST_IP);
  udpReceive.log(true);
  udpReceive.listen(true);

  udpSend = new UDP(this, PORT_RECIPIENT, RECIPIENT_IP);
  udpSend.log(true);
  //udpSend.listen(true);

  drawNow = false;
  drawStartTime = 40000;
  startTimestamp = str(year())+str(month())+str(day())+str(hour())+str(minute());
}

void draw() {

  //if ( millis() - drawStartTime < 30500 ) {
    if (drawNow == true) {

      println(millis() - drawStartTime < 30500, millis() - drawStartTime );
      int rad = int(map(bpm, 40, 800, 150, 10));

      fill(int(random(50, 240)),
        int(random(10, 75)),
        int(random(25, 75)),
        map(rad, 10, 150, 1.0, 0.05));
      //strokeWeight(2);
      //noFill();
      noStroke();
      ellipse( random(100, width-100), random(100, height-100), rad, rad);

      drawNow = !drawNow;

      //saveFrame("animations/dotDemo/"+startTimestamp+"/#####.png");
    //} else {
    //  saveFrame("animations/dotDemo/"+startTimestamp+"/#####.png");
    //}
  }
}

//void initOsc() {
//  oscP5 = new OscP5(HOST_IP, PORT_HOST);
//  ////myRemoteLocation = new NetAddress("10.0.0.7", 8080);
//  myRemoteLocation = new NetAddress(RECIPIENT_IP, PORT_RECIPIENT);

//}


void mousePressed() {
  ///* in the following different ways of creating osc messages are shown by example */
  //OscMessage myMessage = new OscMessage("/start draw shapes");

  ////myMessage.add(123); /* add an int to the osc message */

  ///* send the message */
  //oscP5.send(myMessage, myRemoteLocation);


  drawStartTime = millis();
  background(240, 0, 0, 1); // white, change third entry 100
}

/* incoming osc message are forwarded to the oscEvent method. */
//void oscEvent(OscMessage theOscMessage) {
//  /* print the address pattern and the typetag of the received OscMessage */
//  //print("### received an osc message.");
//  //print(" addrpattern: "+theOscMessage.addrPattern());
//  //print(" typetag: "+theOscMessage.typetag());
//  println(" value: "+ str(theOscMessage.get(0).floatValue()));

//  bpm = theOscMessage.get(0).floatValue();

//  drawNow = !drawNow;
//  println("drawNow = ",drawNow);
//}
