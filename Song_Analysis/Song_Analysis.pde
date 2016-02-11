import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
FFT fft;
float widthConversion;
float sideConversion;

void setup() {
  size(1280, 751);
  minim = new Minim(this);
  //songs: 
  //0. ghosts n gtuff
  //1. dream on
  //2. id love to change the world
  //3. more than a feeling
  song = minim.loadFile("song3.mp3");
  song.play();
  fft = new FFT(song.bufferSize(), song.sampleRate());
  widthConversion = float(width)/fft.specSize();
  println(widthConversion);
  widthConversion = 2;
  sideConversion = float(width)/song.left.size();
  colorMode(HSB);
  textSize(10);
}

void draw() {
  background(0);
  fft.forward(song.mix);
  int averageColor = 0;
  for (int i = 0; i < fft.specSize(); i++) {
    if (i < fft.specSize()/8) {
      averageColor += (360%(fft.getBand(i)*1.9));
    }
    pushMatrix();
    translate(float(width)/2-1, 0);
    stroke((360%(fft.getBand(i)*1.9))+120, 255, 200);
    line(i*widthConversion+1, height/2+fft.getBand(i)*2, i*widthConversion+1, height/2-fft.getBand(i)*2);
    stroke((360%((fft.getBand(i)*1.9) + (fft.getBand(i+1)*1.9))/2)+120, 255, 200);
    line(i*widthConversion+2, ((height/2+fft.getBand(i+1)*2) + (height/2+fft.getBand(i)*2))/2, i*widthConversion+2, ((height/2-fft.getBand(i+1)*2) + (height/2-fft.getBand(i)*2))/2);
    popMatrix();
    pushMatrix();
    translate(float(width)/2, 0);
    scale(-1, 1);
    stroke((360%(fft.getBand(i)*1.9))+120, 255, 200);
    line(i*widthConversion+1, height/2+fft.getBand(i)*2, i*widthConversion+1, height/2-fft.getBand(i)*2);
    stroke((360%((fft.getBand(i)*1.9) + (fft.getBand(i+1)*1.9))/2)+120, 255, 200);
    line(i*widthConversion+2, ((height/2+fft.getBand(i+1)*2) + (height/2+fft.getBand(i)*2))/2, i*widthConversion+2, ((height/2-fft.getBand(i+1)*2) + (height/2-fft.getBand(i)*2))/2);
    popMatrix();
  }
  for (int i = 0; i < song.left.size()-1; i++) {
    stroke(10*averageColor/fft.specSize()+120, 255, 255);
    line(i*sideConversion, height - 100 + song.right.get(i)*50, (i+1) * sideConversion, height - 100 + song.right.get(i+1)*50);
    line(i*sideConversion, 100 + song.left.get(i)*50, (i+1) * sideConversion, 100 + song.left.get(i+1)*50);
  }
  fill(255);
  text("Left", 10, height - 40);  
  text("Right", 10, 160);
}