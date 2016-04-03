import ddf.minim.*;
Minim minim;

AudioInput input;

float magnitude;
int widths = 100;
int heights = 40;
float speed = 50.0;
float factor;
float amplitude = 50;
float amplitude1 = 100;
float amplitude2 = 75;
float amplitude3 = 70;
float step_multiple = 5;
float step_multiple2 = 6;
float step_multiple3 = 7;

float[] peaks = new float[1024];
float[] last_peaks = new float[1024];

float rad1, rad2, rad3;

float step = TWO_PI/340;
float min;

void setup() {
  //size(400, 400);
  fullScreen();
  frameRate(60);
  noStroke();
  noSmooth();
  minim = new Minim(this);
  input = minim.getLineIn(Minim.MONO, 1024);
  factor = float(width)/input.bufferSize();
}

void draw() { 
  background(0);
  blendMode(ADD);
  colorMode(HSB,255);
  //background(frameCount%255, 255, 30);
  colorMode(RGB,255);
  
  
  
  for (int i = 0; i < input.bufferSize() - 1; i++) {
    
    // with linear interpolation:
    peaks[i] = lerp(last_peaks[i], (input.left.get(i)*amplitude), 0.03);
    
    // with NO linear interpolation:
    //peaks[i] = (input.left.get(i)*amplitude);
    
    last_peaks[i] = peaks[i];
  }
  
  
  
  
  rad1 = 0;
  rad1 += frameCount/125.0;
  rad2 = TWO_PI/3;
  rad2 += frameCount/300.0;
  rad3 = 2*(TWO_PI/3);
  rad3 -= frameCount/100.0;
  min = 200;
  for (int i = 0; i < 341; i++) {
    rad1 += step;
    rad2 += step;
    rad3 += step;
    if (i % 5 == 0) {
      beginShape(TRIANGLES);
      fill(0, 0, 255);
      vertex(width/2, height/2);
      vertex(width/2 + sin(rad2)*(peaks[i]*amplitude1 + min*0.50), height/2 + cos(rad2)*(peaks[i]*amplitude1 + min*0.50));
      vertex(width/2 + sin(rad2 + step*step_multiple)*(peaks[i]*amplitude1 + min*0.50), height/2 + cos(rad2 + step*step_multiple)*(peaks[i]*amplitude1 + min*0.50));
      
      fill(0, 255, 0);
      vertex(width/2, height/2);
      vertex(width/2 + sin(rad1)*(peaks[i]*amplitude2 + min*0.75), height/2 + cos(rad1)*(peaks[i]*amplitude2 + min*0.75));
      vertex(width/2 + sin(rad1 + step*step_multiple2)*(peaks[i]*amplitude2 + min*0.75), height/2 + cos(rad1 + step*step_multiple2)*(peaks[i]*amplitude2 + min*0.75));
      
      fill(255, 0, 0);
      vertex(width/2, height/2);
      vertex(width/2 + sin(rad3)*(peaks[i]*amplitude3 + min), height/2 + cos(rad3)*(peaks[i]*amplitude3 + min));
      vertex(width/2 + sin(rad3 + step*step_multiple3)*(peaks[i]*amplitude3 + min), height/2 + cos(rad3 + step*step_multiple3)*(peaks[i]*amplitude3 + min));
      endShape();
    }
  }
}