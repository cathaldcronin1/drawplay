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

PFont f;  // get a font for help info etc
boolean helper = false;
boolean drawing = false;
boolean playing = false;
int curcol = #FF0000;
int curwav = 0;
int startx = 0;
int starty = 0;
int stopx = 0;
int stopy = 0;
int lastcoord = 1; // index to last item added
int curplay = 0;
int mybpm = 120; // the playback speed

void setup()
{
  size(640, 360);
  frameRate(25);
  background(50);
  // Create the font
  f = createFont("SansSerif-12.vlw", 12);
  textFont(f);
  
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
    background(50);
    if(drawing == true)
    {
      // this is when we're drawing a new line in the window
      stroke(255);
      strokeWeight(1);
      line(startx, starty, mouseX, mouseY);
    }
    
    // show the previously drawn lines
    for(i=0; i< lastcoord; i++)
    {  // loop through the arrays
     
      mylines[i].drawit();  // display a line
  
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
    stroke(255);
    strokeWeight(1);
    line(curplay, height, curplay, 0);
  }
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
  thenote.vol(0.1);
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

