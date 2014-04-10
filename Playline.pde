// holds a line for playing
// a playline contains two nodes (from, to), colour of the line, voice (timbre to be used) and
// a boolean, playing, to keep track if it is playing or not, i.e. under the play cursor

class Playline {
  Node from;
  Node to;
  int col;
//  int voice;
//  int start;
//  int end;
  boolean playing;

  Playline(Node a, Node b)
  {
    if(a.x > b.x)
    {
      this.from = a;
      this.to = b;
    }
    else
    {
      this.from = a;
      this.to = b;
    }
  }

  void col(int c)
  {
    this.col = c;
  }

  int getCol()
  {
    return this.col;
  }

  Node getFrom()
  {
    return this.from;
  }

  Node getTo()
  {
    return this.to;
  }

//  void voice(int v)
//  {
//    this.voice = v;
//  }

  void playing(boolean p)
  {
    this.playing = p;
  }

//  void start(int s)
//  {
//    this.start = s;
//  }
//
//  void end(int e)
//  {
//    this.end = e;
//  }

  void drawit(int penWeight)
  {
    stroke(col);
    strokeWeight(penWeight);
    if (from.x >= 0 && to.x >=0 && from.y < 550 && to.y < 550)
    {
      line(from.x, from.y, to.x, to.y);
      if((curplay > from.x)  && (curplay < to.x))
      {
        // the playcursor is over this line
        if(this.playing == false)
        {
          this.playing = true;
        }
      }
      else {
        this.playing = false;
      }
    }
    else
    {
      this.playing = false;
    }
  }

  float tracker()
  {  // calculate if there is any change in pitch due to sloping line
    float alpha = atan((float)(to.y - from.y));
    float update = ((float)curplay - from.x) * sin(alpha);
    return(update + from.y);
  }

}
