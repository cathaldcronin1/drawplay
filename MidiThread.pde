// this is the thread running the timing
// it is based on a thread that is parked/put to sleep and woken up on a timer interupt.

class MidiThread extends Thread 
{
  // this is based on Toxi's code on http://processing.org/discourse/beta/board_Syntax_3Baction_display_3Bnum_1213599231.html

  long previousTime;
  boolean isActive=true;
  double interval;

  MidiThread(double bpm) 
  {
    // interval currently hard coded to sixteenth beats
    interval = 1000.0 / (4 * bpm / 60); 
    previousTime=System.nanoTime();
  }

  void quit() 
  {
    isActive = false;
    interrupt();
  }
  void run() 
  {
    try 
      {
      while(isActive) 
        {
        // calculate time difference since last beat & wait if necessary
        double timePassed=(System.nanoTime()-previousTime)*1.0e-6;
        while(timePassed<interval) {
          timePassed=(System.nanoTime()-previousTime)*1.0e-6;
        }
        if(playing == true)
        {
          // code to advance a step and play notes
          curplay += 2;
          if(curplay > width)
          {
            curplay = 0;
          }
        }
        // calculate the time difference
        long delay=(long)(interval-(System.nanoTime()-previousTime)*1.0e-6);
        previousTime=System.nanoTime();
        
        // check so that thread.sleep wouldn't crash on negative when flipping around
        if(delay < 0)
        { 
          delay = 1;
        }
        // park the thread
        Thread.sleep(delay);
      }
    } 
    // catch if in trouble
    catch(InterruptedException e) 
    {
    //  println("force quit...");
    }
  }
} 

// shutdown the midi thread when the applet is stopped
public void stop() {
    if (midi!=null) midi.isActive=false;
    super.stop();
}



