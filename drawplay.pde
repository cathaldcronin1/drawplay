import g4p_controls.*;


/* drawaplay
* code example for assignment in CS4358
* academic year 2013/14 spring semester
*  Mikael Fernström
*  2014-02-08
*/

// we need the library for the audio API
import ddf.minim.*;
import ddf.minim.ugens.*;

// define the minim,  midi and output
Minim minim;
MidiThread midi;
AudioOutput out;

int MAXITEMS = 100;

// set up arrays to hold lines and tones
Playline[] mylines = new Playline[MAXITEMS];
Playnote[] mynotes = new Playnote[MAXITEMS];

boolean helper = false;
boolean drawing = false;
boolean playing = false;
int curcol = #FF0000;

color myPenStroke;
int myPenWeight;
PFont f;
String tool;
boolean clear = false;

int curwav = 0;
int startx = 0;
int starty = 0;
int stopx = 0;
int stopy = 0;
int lastcoord = 1; // index to last item added
int curplay = 175;
int mybpm = 120; // the playback speed
float current_vol = 0.1;

int oldMouseX, oldMouseY;

// GP4 GUI
GCustomSlider slider;

GOption red_checkbox ;
GOption blue_checkbox ;
GOption green_checkbox ;
GOption yellow_checkbox ;

GPanel panel1;
GToggleGroup colours;

void setup()
{
  createGUI();
  size(800, 800);
  frameRate(25);
  // Create the font
  f = createFont("SansSerif-12.vlw", 12);
  myPenStroke = color(0, 0, 0);
  myPenWeight = 1;
  textFont(f);

  tool = "Tools";
  background(#E8DCDC);
  line (175, 0, 175, 800);
  // fill (0);
  // text (tool, 40, 30);
  // fill (#2723B7);
  // text ("Colors", 10, 50);
  // text ("Line Effects", 10, 120);
  // text ("Erase", 10, 200);
  // text ("Clear Screen", 10, 310);

  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);
  out = minim.getLineOut();

  Node here = new Node(0, 0);
  Node there = new Node(0, 0);
  Playline theline = new Playline(here, there);
  theline.playing = false;

  Playnote thenote = new Playnote(0);
  thenote.playing = false;

  // initialise the array
  int i = 0;
  for(i=0; i<100; i++)
  {
    mylines[i] = theline;
    mynotes[i] = thenote;

  }

  // let's start the MIDI thread for timing
  midi=new MidiThread(120); // this is 120 BPM as initial tempo
  midi.start();
}
void draw()
{
  int i = 0;

  float deltaf = 0;  // to keep track of change in pitch

  if(helper == true)
  { // show the help screen
    showHelp();
  }
  else
  { // normal playing
    background(255);
    if(drawing == true)
    {
      // this is when we're drawing a new line in the window
      strokeWeight(myPenWeight);
      stroke(myPenStroke);
      line(startx, starty, mouseX, mouseY);
    }

  //color buttons
  //red button
  fill(255, 0, 0);
  // stroke(0);
  // strokeWeight(1);
  // ellipse(20, 80, 20, 20);
  // if (mousePressed && dist(20, 80, mouseX, mouseY) < 10) {
  //   curcol = color(255, 0, 0);
  //   curwav = 1;
  // }
  // //green button
  // fill(0, 255, 0);
  // stroke(0);
  // strokeWeight(1);
  // ellipse(40, 80, 20, 20);
  // if (mousePressed && dist(40, 80, mouseX, mouseY) < 10) {
  //   curcol = color(0, 255, 0);
  //   curwav = 2;
  // }
  // //blue button
  // fill(0, 0, 255);
  // stroke(0);
  // strokeWeight(1);
  // ellipse(60, 80, 20, 20);
  // if (mousePressed && dist(60, 80, mouseX, mouseY) < 10) {
  //   curcol = color(0, 0, 255);
  //   curwav = 3;
  // }

  // //yellow button
  // fill(#FEFF03);
  // stroke(0);
  // strokeWeight(1);
  // ellipse(80, 80, 20, 20);
  // if (mousePressed && dist(80, 80, mouseX, mouseY) < 10) {
  //   curcol = color(#FEFF03);
  //   curwav = 4;
  // }

/* // //line thickness and tips
  // //thin line button
  // stroke(0);
  // strokeWeight(1);
  // line(20, 130, 20, 150);
  // if (mousePressed && mouseX > 10 && mouseX <30 && mouseY > 120 && mouseY < 160) {
  //   if (myPenWeight > 0) {
  //     myPenWeight --;
  //   }
  // }
  // //thick line button 5
  // stroke(0);
  // strokeWeight(5);
  // line(40, 130, 40, 150);
  // if (mousePressed && mouseX > 30 && mouseX <50 && mouseY > 120 && mouseY < 160) {
  //   myPenWeight = 5;
  // }

  // //thick line button 8
  // stroke(0);
  // strokeWeight(8);
  // line(60, 130, 60, 150);
  // if (mousePressed && mouseX > 50 && mouseX <70 && mouseY > 120 && mouseY < 160) {
  //   myPenWeight = 8;
  // }
  // //thick line button 12
  // stroke(0);
  // strokeWeight(12);
  // line(80, 130, 80, 150);
  // if (mousePressed && mouseX > 70 && mouseX <90 && mouseY > 120 && mouseY < 160) {
  //   myPenWeight = 12;
  // }
  // //thick line button 16
  // stroke(0);
  // strokeWeight(16);
  // line(100, 130, 100, 150);
  // if (mousePressed && mouseX > 90 && mouseX <110 && mouseY > 120 && mouseY < 160) {
  //   myPenWeight = 16;
  // }

  // //erase
  // fill (225);
  // ellipse (30, 245, 40, 40);
  // stroke(0);
  // strokeWeight(1);
  // if (mousePressed && dist(30, 245, mouseX, mouseY) < 10) {
  //   myPenStroke = color(#E8DCDC);
  //   myPenWeight = 18;
  // }
  // //clear screen
  // fill(255);
  // strokeWeight(1);
  // stroke(0);
  // ellipse (20, 340, 40, 40); {
  //   if (mousePressed && dist(20, 340, mouseX, mouseY) < 10) {
  //     background (#E8DCDC);
  //     myPenWeight = 1;
  //     tool = "Tools";
  // background (#E8DCDC);
  //  }*/
  }
  // line (175, 0, 175, 800);
  // fill (0);
  // text (tool, 40, 30);
  // fill (#2723B7);
  // text ("Colors", 10, 50);
  // text ("Line Effects", 10, 120);
  // text ("Erase", 10, 200);
  // text ("Clear Screen", 10, 310);

    // show the previously drawn lines
    for(i=0; i< lastcoord; i++)
    {  // loop through the arrays

      mylines[i].drawit(myPenWeight);  // display a line

      if(mylines[i].playing != mynotes[i].playing)
      { //a line is there but we're not playing yet
        if(mylines[i].playing == true)
        { //if the line is there, start playing
          mynotes[i].noteOn( 1.0f / mynotes[i].dura);
          mynotes[i].playing = true;
        }
        else
        {  // there's no line here, so stop playing
          mynotes[i].noteOff();
          mynotes[i].playing = false;
        }
      }
      if(mynotes[i].playing == true)
      {  // update the pitch of a line playing
        deltaf = mylines[i].tracker();
        mynotes[i].freq(200 + (1000 * (height - deltaf) / height));
      }
    }


   // show the play cursor, a vertical line moving across the window
  stroke(0);
  strokeWeight(1);
  line(curplay, height, curplay, 0);

}

public void red_checkbox_clicked(GOption source, GEvent event)
{
  curcol = color(255, 0, 0);
  curwav = 1;
}

public void blue_checkbox_clicked(GOption source, GEvent event)
{
  curcol = color(0, 0, 255);
  curwav = 2;
}

public void green_checkbox_clicked(GOption source, GEvent event)
{
  curcol = color(0, 255, 0);
  curwav = 3;
}

public void yellow_checkbox_clicked(GOption source, GEvent event)
{
  curcol = color(#FEFF03);
  curwav = 4;
}

public void volume_control(GCustomSlider source, GEvent event)
{
  current_vol = source.getValueF();
}

void createGUI()
{
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  if(frame != null)
    frame.setTitle("Drawplay");
  panel1 = new GPanel(this, 0, 635, 800, 164, "Drawplay");
  panel1.setText("Tab bar text");
  panel1.setOpaque(true);
  panel1.addEventHandler(this, "panel1_Click1");
  panel1.setDraggable(false);
  panel1.setCollapsible(false);

  colours = new GToggleGroup();

  red_checkbox = new GOption(this, 10, 35, 120, 20);
  red_checkbox.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  red_checkbox.setText("Red");
  red_checkbox.setTextBold();
  red_checkbox.setOpaque(false);
  red_checkbox.addEventHandler(this, "red_checkbox_clicked");

  blue_checkbox = new GOption(this, 10, 65, 120, 20);
  blue_checkbox.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  blue_checkbox.setText("Blue");
  blue_checkbox.setOpaque(false);
  blue_checkbox.addEventHandler(this, "blue_checkbox_clicked");

  green_checkbox = new GOption(this, 10, 95, 120, 20);
  green_checkbox.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  green_checkbox.setText("Green");
  green_checkbox.setOpaque(false);
  green_checkbox.addEventHandler(this, "green_checkbox_clicked");

  yellow_checkbox = new GOption(this, 10, 120, 120, 20);
  yellow_checkbox.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  yellow_checkbox.setText("Yellow");
  yellow_checkbox.setText("Yellow");
  yellow_checkbox.setOpaque(false);
  yellow_checkbox.addEventHandler(this, "yellow_checkbox_clicked");

  colours.addControl(red_checkbox);
  colours.addControl(blue_checkbox);
  colours.addControl(green_checkbox);
  colours.addControl(yellow_checkbox);

  slider = new GCustomSlider(this, 350, 62, 253, 50, "blue18px");
  slider.setShowValue(true);
  slider.setShowLimits(true);
  slider.setLimits(current_vol, 0, 1);
  slider.setNumberFormat(G4P.DECIMAL, 1);
  slider.setOpaque(false);
  slider.addEventHandler(this, "volume_control");

  panel1.addControl(slider);
  panel1.addControl(red_checkbox);
  panel1.addControl(blue_checkbox);
  panel1.addControl(green_checkbox);
  panel1.addControl(yellow_checkbox);
}
/********************************/
// if the user presses the keyboard
void keyPressed()
{
  if(key == 'h' || key == 'H')
  { // show help on screen, toggle when pressed repeatedly
    if(helper == false)
    {
      showHelp();
      helper = true;
    }
    else
    {
      background(50);
      helper = false;
    }
  }

  if(key == 'q' || key == 'Q')
  { // quit the program
    out.close();
    minim.stop();
    stop();
    exit();
  }
  if(key == '1')
  { // set colour
    //println("red");
    curcol = #FF0000;
    curwav = 0;
  }
  if(key == '2')
  { // set colour
    //println("green");
    curcol = #00FF00;
    curwav = 1;
  }
  if(key == '3')
  { // set colour
    //println("blue");
    curcol = #0000FF;
    curwav = 2;
  }
  if(key == '4')
  { // set colour
    //println("yellow");
    curcol = #FFFF00;
    curwav = 3;
  }
  // change play speed with arrowkeys, UP/DOWN
  if (key == CODED)
  {
    if (keyCode == UP) // increase tempo
    {
      mybpm += 10;
    }
    if (keyCode == DOWN) // decrease tempo
    {
      mybpm -= 10;
      if(mybpm < 1)
      {
        mybpm = 1;
      }
    }
   midi.quit(); // stop the thread
   midi=new MidiThread(mybpm); // set the new bpm value
   midi.start(); // start the thread again
  }
  // play/stop using the space bar
  if(key == ' ')
  {
    if(playing == false)
    {
      playing = true;
//      println("PLAYING");
    }
    else
    {
      playing = false;
//      println("STOPPED");
    }
  }
}

/********************************/
void showHelp()
{
  background(50);
  String s = "HELP \n" +
             "Press space bar to start/stop playing\n" +
             "1: red sinewave\n" +
             "2: green squarewave\n" +
             "3: blue trianglewave\n" +
             "4: yellow pulsetrain\n" +
             "UP-arrow increase speed\n" +
             "DOWN-arrow decrease speed\n" +
             "Q for quit";
  textAlign(LEFT);
  text(s, 10, 10, 620, 340);
}

/********************************/
void mousePressed()
{ // start drawing
  drawing = true;
  startP(mouseX, mouseY);
  cursor(CROSS);
}

/********************************/
void mouseReleased()
{ // stop drawing
  drawing = false;
  stopP(mouseX, mouseY);
  Node here = new Node(startx, starty);
  Node there = new Node(stopx, stopy);
  Playline theline = new Playline(here, there);
  Playnote thenote = new Playnote(curwav);
  thenote.vol(current_vol);
  if(stopx > startx)
  {
    thenote.freq(200 + (1000 * (height - starty) / height));
    thenote.dura((stopx - startx)/width);
  }
  else
  {
    thenote.freq(200 + (1000 * (height - stopy) / height));
    thenote.dura((startx - stopx)/width);
  }
  theline.col = curcol;
  cursor(ARROW);
  // copy to the arrays
  mylines[lastcoord] = theline;
  mynotes[lastcoord] = thenote;

  if(lastcoord < MAXITEMS)
  {
    lastcoord++;
  }
}

/********************************/
void startP(int x, int y)
{
  startx = x;
  starty = y;
}

/********************************/
void stopP(int x, int y)
{
  stopx = x;
  stopy = y;
}

