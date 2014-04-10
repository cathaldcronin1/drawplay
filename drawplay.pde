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
// Playline[] mylines = new Playline[MAXITEMS];
// Playnote[] mynotes = new Playnote[MAXITEMS];

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
int lastcoord = 1; // index to last item added
int curplay = 0;
int mybpm = 120; // the playback speed
float current_vol = 0.1;

int oldMouseX, oldMouseY;

// GP4 GUI
GPanel panel1;

GButton save_lines;
GButton load_lines;

GButton play_button;
GButton stop_button;
GButton quit_button;

GButton undo;
GButton redo;

GCustomSlider red_slider;
GCustomSlider blue_slider;
GCustomSlider green_slider;
GCustomSlider yellow_slider;

GToggleGroup colours;

GOption red_checkbox ;
GOption blue_checkbox ;
GOption green_checkbox ;
GOption yellow_checkbox ;

GButton clear_screen;

JSONArray saved_lines;

GKnob bpm_knob;
GLabel label;

void setup()
{
  createGUI();
  size(800, 800);
  frameRate(25);
  // Create the font
  f = createFont("SansSerif-12.vlw", 12);
  myPenStroke = color(0, 0, 0);
  myPenWeight = 10;
  textFont(f);

  tool = "Tools";
  background(#E8DCDC);
  line (175, 0, 175, 800);
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

//color buttons
  //red button
  // fill(255, 0, 0);
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
    for(i=0; i< mylines.size(); i++)
    {
        // mylines[i].drawit(myPenWeight);  // display a line

        mylines.get(i).drawit(myPenWeight);

        if(mylines.get(i).playing != mynotes.get(i).playing)
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
        if(mynotes.get(i).playing == true)
        {  // update the pitch of a line playing
          deltaf = mylines.get(i).tracker();
          mynotes.get(i).freq(200 + (1000 * (height - deltaf) / height));
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

public void red_vol_control(GCustomSlider source, GEvent event)
{
  println(source);
    for (int i = 0; i < mynotes.size(); i++)
    {
      if(mylines.get(i).getCol() == #FF0000)
      {
        mynotes.get(i).vol(source.getValueF());
      }
    }
}

public void green_vol_control(GCustomSlider source, GEvent event)
{

    for (int i = 0; i < mynotes.size(); i++)
    {
      if(mylines.get(i).getCol() == #00FF00)
      {
        mynotes.get(i).vol(source.getValueF());
      }
    }
}

public void blue_vol_control(GCustomSlider source, GEvent event)
{
  for (int i = 0; i < mynotes.size(); i++)
    {
      if(mylines.get(i).getCol() == #0000FF)
      {
        mynotes.get(i).vol(source.getValueF());
      }
    }
}

public void yellow_vol_control(GCustomSlider source, GEvent event)
{
  for (int i = 0; i < mynotes.size(); i++)
    {
      if(mylines.get(i).getCol() == #FFFF00)
      {
        mynotes.get(i).vol(source.getValueF());
      }
    }
}

public void save_clicked(GButton button, GEvent event)
{
  selectOutput("Select a file to write to:", "saveFile");
}

public void load_clicked(GButton button, GEvent event)
{
  // selectInput("Choose file to Load");
  selectInput("Select a file to process:", "loadFile");
}

void saveFile(File selection)
{
  if (selection == null)
  {
    println("Window was closed or the user hit cancel.");
  }
  else
  {
    println("Saved to... " + selection.getAbsolutePath());
    saveLines();
    saveJSONArray(saved_lines, selection.getAbsolutePath());
  }
}

void loadFile(File selection)
{
  if (selection == null)
  {
    println("Window was closed or the user hit cancel.");
  }
  else
  {
    String file = selection.getAbsolutePath();
    loadLines(file);
  }
}

void saveLines()
{
   for(int i = 0; i < mylines.size(); i++)
   {
      // create json line object
      JSONObject line_to_save = new JSONObject();
      int line_col = mylines.get(i).getCol();

      // x1 y1
      int x1 = mylines.get(i).getFrom().getX();
      int y1 = mylines.get(i).getFrom().getY();

      // x2 y2
      int x2 = mylines.get(i).getTo().getX();
      int y2 = mylines.get(i).getTo().getY();

      // set from x value
      line_to_save.setInt("from_x1", x1);

      // set from y value
      line_to_save.setInt("from_y1", y1);

      // set to x value
      line_to_save.setInt("to_x2", x2);

      // set to y value
      line_to_save.setInt("to_y2", y2);

      // set colour of line
      line_to_save.setInt("col", line_col);

      // add line to array of JSON lines
      saved_lines.append(line_to_save);
   }

}

void loadLines(String file)
{
  saved_lines = loadJSONArray(file);
  println("File loaded:" + saved_lines);
  for (int i = 0; i < saved_lines.size(); i++)
  {

    JSONObject saved_line = saved_lines.getJSONObject(i);

    int col = saved_line.getInt("col");
    int x1 = saved_line.getInt("from_x1");
    int y1 = saved_line.getInt("from_y1");
    int x2 = saved_line.getInt("to_x2");
    int y2 = saved_line.getInt("to_y2");

    Node here = new Node(x1, y1);
    Node there = new Node(x2, y2);
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
      theline.col = col;
      mylines.add(theline);
      mynotes.add(thenote);
  }
}

public void speed_knob(GKnob source, GEvent event)
{
  mybpm = source.getValueI();
  midi.quit(); // stop the thread
  midi = new MidiThread(mybpm); // set the new bpm value
  midi.start(); // start the thread again
}

public void panel1_Click1(GPanel panel, GEvent event)
{
  // Do Nothing
}

public void Play_Clicked(GButton button, GEvent event)
{
  playing = true;
}

public void Stop_Clicked(GButton button, GEvent event)
{
  playing = false;
}

public void Clear_Clicked(GButton button, GEvent event)
{
  mylines.clear();
  mynotes.clear();
  minim.stop();
  out = minim.getLineOut();
}

public void Quit_Clicked(GButton button, GEvent event)
{
    out.close();
    minim.stop();
    stop();
    exit();
}

public void undo_clicked(GButton button, GEvent event)
{
  if (mylines.size() > 0)
  {

    int last_element = mylines.size() - 1;
    println(last_element);

    //Store line
    undid_lines.add(mylines.get(last_element));

    // Remove last line in mylines
    mylines.remove(last_element);

    minim.stop();
    out = minim.getLineOut();
  }
}

public void redo_clicked(GButton button, GEvent event)
{
  if (undid_lines.size() > 0)
  {

    int last_element = undid_lines.size() - 1;

    // For each line that was undid, add back
    mylines.add(undid_lines.get(last_element));
    undid_lines.remove(last_element);

    minim = new Minim(this);
    out = minim.getLineOut();
  }
}

void createGUI()
{
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  if(frame != null)
    frame.setTitle("Drawplay");
  panel1 = new GPanel(this, 0, 550, 800, 250, "Drawplay");
  panel1.setOpaque(true);
  panel1.addEventHandler(this, "panel1_Click1");
  panel1.setDraggable(false);
  panel1.setCollapsible(false);

  colours = new GToggleGroup();

  red_checkbox = new GOption(this, 10, 50, 120, 20);
  red_checkbox.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  red_checkbox.setText("Red");
  red_checkbox.setTextBold();
  red_checkbox.setOpaque(false);
  red_checkbox.addEventHandler(this, "red_checkbox_clicked");
  red_checkbox.setLocalColorScheme(GCScheme.RED_SCHEME);

  blue_checkbox = new GOption(this, 10, 95, 120, 20);
  blue_checkbox.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  blue_checkbox.setText("Blue");
  blue_checkbox.setOpaque(false);
  blue_checkbox.addEventHandler(this, "blue_checkbox_clicked");

  green_checkbox = new GOption(this, 10, 140, 120, 20);
  green_checkbox.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  green_checkbox.setText("Green");
  green_checkbox.setOpaque(false);
  green_checkbox.addEventHandler(this, "green_checkbox_clicked");

  yellow_checkbox = new GOption(this, 10, 185, 120, 20);
  yellow_checkbox.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  yellow_checkbox.setText("Yellow");
  yellow_checkbox.setOpaque(false);
  yellow_checkbox.addEventHandler(this, "yellow_checkbox_clicked");

  colours.addControl(red_checkbox);
  colours.addControl(blue_checkbox);
  colours.addControl(green_checkbox);
  colours.addControl(yellow_checkbox);

  red_slider    = new GCustomSlider(this, 70, 15, 99, 80,  "blue18px");
  blue_slider   = new GCustomSlider(this, 70, 65, 99, 80,  "blue18px");
  green_slider  = new GCustomSlider(this, 70, 110, 99, 80, "blue18px");
  yellow_slider = new GCustomSlider(this, 70, 165, 99, 80, "blue18px");

  // red_slider.setShowValue(true);
  red_slider.setShowLimits(true);
  red_slider.setLimits(current_vol, 0, 1);
  red_slider.setNumberFormat(G4P.DECIMAL, 1);
  red_slider.setOpaque(false);
  red_slider.addEventHandler(this, "red_vol_control");

  // blue_slider.setShowValue(true);
  blue_slider.setShowLimits(true);
  blue_slider.setLimits(current_vol, 0, 1);
  blue_slider.setNumberFormat(G4P.DECIMAL, 1);
  blue_slider.setOpaque(false);
  blue_slider.addEventHandler(this, "blue_vol_control");

  // green_slider.setShowValue(true);
  green_slider.setShowLimits(true);
  green_slider.setLimits(current_vol, 0, 1);
  green_slider.setNumberFormat(G4P.DECIMAL, 1);
  green_slider.setOpaque(false);
  green_slider.addEventHandler(this, "green_vol_control");

  // yellow_slider.setShowValue(true);
  yellow_slider.setShowLimits(true);
  yellow_slider.setLimits(current_vol, 0, 1);
  yellow_slider.setNumberFormat(G4P.DECIMAL, 1);
  yellow_slider.setOpaque(false);
  yellow_slider.addEventHandler(this, "yellow_vol_control");



  bpm_knob = new GKnob(this, 225, 70, 100, 100, 0.8);
  bpm_knob.setTurnRange(180, 0);
  bpm_knob.setTurnMode(GKnob.CTRL_HORIZONTAL);
  bpm_knob.setSensitivity(1);
  bpm_knob.setShowArcOnly(true);
  bpm_knob.setOverArcOnly(true);
  bpm_knob.setIncludeOverBezel(true);
  bpm_knob.setShowTrack(true);
  bpm_knob.setLimits(mybpm, 120, 240);
  bpm_knob.setShowTicks(true);
  bpm_knob.setOpaque(false);
  bpm_knob.addEventHandler(this, "speed_knob");
  bpm_knob.setShowValue(true);

  label = new GLabel(this, 225, 90, 100, 100, "BPM Control");
  panel1.addControl(label);

  play_button   = new GButton(this, 600, 30, 80, 30, "Play");
  undo          = new GButton(this, 600, 70, 80, 30, "Undo");
  save_lines    = new GButton(this, 600, 110, 80, 30, "Save");
  clear_screen  = new GButton(this, 600, 150, 80, 30, "Clear");

  stop_button   = new GButton(this, 700, 30, 80, 30, "Stop");
  redo          = new GButton(this, 700, 70, 80, 30, "Redo");
  load_lines    = new GButton(this, 700, 110, 80, 30, "Load");
  quit_button   = new GButton(this, 700, 150, 80, 30, "Quit");

  play_button.addEventHandler(this, "Play_Clicked");
  stop_button.addEventHandler(this, "Stop_Clicked");
  clear_screen.addEventHandler(this, "Clear_Clicked");
  quit_button.addEventHandler(this, "Quit_Clicked");
  save_lines.addEventHandler(this, "save_clicked");
  load_lines.addEventHandler(this, "load_clicked");
  undo.addEventHandler(this, "undo_clicked");
  redo.addEventHandler(this, "redo_clicked");

  panel1.addControl(play_button);
  panel1.addControl(stop_button);
  panel1.addControl(quit_button);
  panel1.addControl(undo);
  panel1.addControl(redo);

  panel1.addControl(bpm_knob);
  panel1.addControl(save_lines);
  panel1.addControl(load_lines);

  panel1.addControl(red_slider);
  panel1.addControl(blue_slider);
  panel1.addControl(green_slider);
  panel1.addControl(yellow_slider);

  panel1.addControl(clear_screen);
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
   // midi.quit(); // stop the thread
   // midi=new MidiThread(mybpm); // set the new bpm value
   // midi.start(); // start the thread again
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

