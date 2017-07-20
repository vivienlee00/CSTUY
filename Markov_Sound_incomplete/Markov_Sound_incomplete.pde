import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

void setup()
{
  size(512, 200);
  
  minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  out.setTempo( 80 );
}

void draw(){
  background(0);
  out.playNote(0,"A4");
}

  