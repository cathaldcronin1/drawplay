// tones for playing

class Playnote {
  Oscil mynote;
  int wav;
  float freq;
  float dura;
  float vol;
  boolean playing;

  Playnote(int x)
  {
        switch(x)
    {
      case 0:
        mynote = new Oscil( 0.0f, 0.0f, Waves.SINE );
        break;
      case 1:
        mynote = new Oscil( 0.0f, 0.0f, Waves.SQUARE );
        break;
      case 2:
        mynote = new Oscil( 0.0f, 0.0f, Waves.SAW );
        break;
      case 3:
        mynote = new Oscil( 0.0f, 0.0f, Waves.QUARTERPULSE);
        break;
      default:
        mynote = new Oscil( 0.0f, 0.0f, Waves.SINE );
        break;
    }
  }

/**********************/
  void freq(float p)
  {
    this.freq = p;
    mynote.setFrequency(p);
//    println(p);
  }

/**********************/
  void vol(float v)
  {
    this.vol = v;
    mynote.setAmplitude(v);
  }

/**********************/
  void dura(float d)
  {
    this.dura = d;
  }

/**********************/
  void wav(int w)
  {
    this.wav = w;
  }

/**********************/
  void noteOn( float dur )
  {
    // the tone oscillator is patched to the output.
    mynote.patch( out );
  }

/**********************/
  void noteOff()
  {
    // unpatch the tone oscillator when the note is over
    mynote.unpatch( out );
  }

/**********************/
  void playing(boolean p)
  {
    this.playing = p;
  }
}
