import java.text.DecimalFormat;

DecimalFormat df = new DecimalFormat("00.00");

double incr;
int iteration = 0;

double x;
double y;
double real;
double imag;

double lastX;
double lastY;

double pi;

long startTime;
long currentTime;
                                                    
float scale = 150;

PGraphics graph;
PGraphics ro;

void setup() {
  size(800, 600, P2D);
  graph = createGraphics(width, 200, P2D);
  ro = createGraphics(300, 16384, P2D);
  
  new Thread(new CalcPi(0.00000001)).start();
}

void draw() {
  background(0);
  pushMatrix();
  translate(width * .65, height * .5);
  fill(0xFF007F00);
  stroke(0xFF00FF00);
  pushMatrix();
  arc(0, 0, scale * 2, scale * 2, 0, atan2((float)y, (float)x));
  popMatrix();
  noFill();
  arc(0, 0, scale * 2, scale * 2, 0, PI, CHORD);
  strokeWeight(2);
  line(0, 0, (float)x * scale, (float)y * scale);
  strokeWeight(1);
  fill(0xFFFF0000);
  pushMatrix();
  translate((float)x * scale, (float)y * scale);
  noStroke();
  ellipse(0, 0, 10, 10);
  fill(0x7F000000);
  rect(10, 0, 105, textAscent());
  fill(0xFFFF0000);
  text(df.format(x) + " + " + df.format(y) + "i", 10, 10);
  popMatrix();
  popMatrix();
  
  
  double proportion = (pi / Math.PI) * 100;
  long duration = (currentTime - startTime);
  float seconds = (float)(duration / 10) / 100;
  int minutes = (int)(seconds / 60);
  double ratio = ((1 - (pi / Math.PI)) * duration);
  
  //ro.clear();
  stroke(0xFFFF0000);
  fill(0xFF110000);
  noStroke();
  rect(0, -textAscent(), 300, 100);
  stroke(0xFFFF0000);
  line(0, -textAscent(), 300, -textAscent());
  fill(0xFFFF0000);
  text("iteration: " + (iteration + 1), 0, textAscent() * 0);
  text("π ≈         " + pi, 0, textAscent() * 1);
  text("Math.PI = " + Math.PI + "...", 0, textAscent() * 2);
  text("proportion: " + proportion + "%", 0, textAscent() * 3);
  text("duration: " + minutes + "m " + df.format(seconds % 60) + "s" , 0, textAscent() * 4);
  text("(1 - accuracy) * duration: " + ratio, 0, textAscent() * 5);
  
  text("increment: " + incr, 0, textAscent() * 7);
}

class CalcPi implements Runnable {
  CalcPi(double increment) {
    incr = increment;
  }
  
  void run() {
    while (iteration < 1) {
      x = 1;
      y = 0;
      real = 1;
      imag = incr;
      
      pi = 0;
  
      startTime = System.currentTimeMillis();
      currentTime = System.currentTimeMillis();
      
      while (!(y < 0)) {
        currentTime = System.currentTimeMillis();
        lastX = x;
        lastY = y;
        
        x = x * real - y * imag;
        y = x * imag + y * real;
        
        double xdiff = x - lastX;
        double ydiff = y - lastY;
        
        pi += Math.sqrt(xdiff * xdiff + ydiff * ydiff);
      }
      
      incr = incr / 10;
      iteration++;
    }
  }
}
