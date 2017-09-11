
class Pt {
  public float x;
  public float y;
  public float vx;
  public float vy;
}

int L = 10;
int N = 30;
Pt[] pts = new Pt[N];

void setup() {
  size(640, 480);
  for (int i = 0;i < N;i ++) {
    pts[i]= new Pt();
    pts[i].x =320;
    pts[i].y = i*L;
    pts[i].vx = 0;
    pts[i].vy = 0;
  }
}

void simStrings() {
  pts[0].x = mouseX;
  pts[0].y = mouseY;
  for (int i = 1;i < N;i ++) {
    float dx = pts[i].x-pts[i-1].x;
    float dy = pts[i].y-pts[i-1].y;
    float dr = sqrt(dx*dx+dy*dy);
    float nx = pts[i-1].x+L*dx/dr;
    float ny = pts[i-1].y+L*dy/dr;
    pts[i].vx += (nx-pts[i].x)*0.01;
    pts[i].vy += (ny-pts[i].y)*0.01;
    pts[i].x = nx;
    pts[i].y = ny;
    pts[i].vx *= 0.98;
    pts[i].vy *= 0.98;
  }
  for (int i = 0;i < N;i ++) {
    pts[i].vy += 0.2;
    pts[i].x += pts[i].vx;
    pts[i].y += pts[i].vy;
  }
  pts[0].x = mouseX;
  pts[0].y = mouseY;
}

void draw() {
  background(0);
  simStrings();
  strokeWeight(5);
  stroke(250, 250, 250);
  for (int i = 0;i < N-1;i ++) {
    line(pts[i].x, pts[i].y, pts[i+1].x, pts[i+1].y);
  }
  fill(250, 250, 250);
  ellipse(mouseX, mouseY, 20, 20);
  
  saveFrame("frames/#####.tif");
}