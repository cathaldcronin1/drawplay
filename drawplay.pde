/* drawaplay
* code for assignment in CS4358
* 2014
* Cathal Cronin
*/

// GUI Library
import g4p_controls.*;

// we need the library for the audio API
import ddf.minim.*;
import ddf.minim.ugens.*;

// define the minim,  midi and output
Minim minim;
MidiThread midi;
AudioOutput out;

// Create Arraylists to hold lines and tones
ArrayList<Playline> mylines = new ArrayList<Playline>();
ArrayList<Playnote> mynotes = new ArrayList<Playnote>();
ArrayList<Playline> undid_lines = new ArrayList<Playline>();

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
int curplay = 0;
int mybpm = 120; // the playback speed
float current_vol = 0.1;

int oldMouseX, oldMouseY;

// JSON array to hold JSON formatted line objects. 
// Used for saving and loading functionality.
JSONArray saved_lines;

void setup()
{
  // Build GUI
  createGUI();
  size(800, 800);
  frameRate(25);
  // Create the font
  f = createFont("SansSerif-12.vlw", 12);
  myPenStroke = color(0, 0, 0);
  myPenWeight = 10;
  textFont(f);
  background(#E1E1E1);
  line (175, 0, 175, 800);

  // Hold lines to be saved.
  saved_lines = new JSONArray();

  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);
  out = minim.getLineOut();

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

  }

  // show the previously drawn lines
  if(helper == false)
  {
    for(i=0; i< mylines.size(); i++)
    {
        // display a line
        mylines.get(i).drawit(myPenWeight);

        if(mylines.get(i).playing != mynotes.get(i).playing && playing == true)
        { //a line is there but we're not playing yet
          if(mylines.get(i).playing == true)
          { //if the line is there, start playing
            mynotes.get(i).noteOn( 1.0f / mynotes.get(i).dura);
            mynotes.get(i).playing = true;
          }
          else
          {  // there's no line here, so stop playing
            mynotes.get(i).noteOff();
            mynotes.get(i).playing = false;
          }
        }
        else if(mynotes.get(i).playing == true)
        {  // update the pitch of a line playing
          deltaf = mylines.get(i).tracker();
          mynotes.get(i).freq(200 + (1000 * (height - deltaf) / height));
        }
        else if(playing == false)
        {
          mynotes.get(i).noteOff();
          mynotes.get(i).playing = false;
        }
      }
  }

   // show the play cursor, a vertical line moving across the window
  stroke(0);
  strokeWeight(1);
  line(curplay, height, curplay, 0);

}

void showHelp()
{
  background(50);
  String s = "HELP \n" +
             "Draw Lines by holding a mouse button down, dragging and then releasing.\n\n" +
             "Choose from 4 line colours. \n" +
             "Each colour represents a different soundwave . \n" +
             "Colour: red, Wave: sinewave\n" +
             "Colour: green, Wave: squarewave\n" +
             "Colour: blue, Wave: trianglewave\n" +
             "Colour: yellow, Wave: pulsetrain\n" +
             "Adjust speed with BPM Knob\n" +
             "Play: Start playing. \n" +
             "Stop: Stop playing. \n" +
             "Undo: Deletes previously drawn line.\n" +
             "Redo: Redraws lines which were undone.\n" +
             "Clear: Clears all lines from screen, CANNOT BE UNDONE.\n" +
             "Save: Allows you to save currently drawn lines to a file.\n" +
             "Load: Allows you to load files from the chosen .\n";

  textAlign(LEFT);
  text(s, 10, 10, 620, 340);
}
void keyPressed()
{
  // play/stop using the space bar
  if(key == ' ')
  {
    if(playing == false)
    {
      playing = true;
      for(int i = 0; i < mylines.size(); i++)
      {
        mynotes.get(i).noteOn( 1.0f / mynotes.get(i).dura);
        mynotes.get(i).playing = true;
      }
    }
    else
    {
      playing = false;
      for(int i = 0; i < mylines.size(); i++)
      {
        mynotes.get(i).noteOff();
        mynotes.get(i).playing = false;
      }
    }
  }
}

void mousePressed()
{ // start drawing
  drawing = true;
  if (helper!= true)
  {
    startP(mouseX, mouseY);
    cursor(CROSS);
  }
}

/********************************/
void mouseReleased()
{ // stop drawing
  drawing = false;
  stopP(mouseX, mouseY);
  if (starty < 550 && stopy < 550)
  {

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
    mylines.add(theline);
    mynotes.add(thenote);
  }
}

void startP(int x, int y)
{
  startx = x;
  starty = y;
}

void stopP(int x, int y)
{
  stopx = x;
  stopy = y;
}
