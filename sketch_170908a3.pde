
class Cell {
  public int cd;
  public float x;
  public float y;
  public float r;
  public float vx;
  public float vy;
}

int N = 100;
Cell cells[] = new Cell[N];

float z[]= new float[640*480];
float dz_dt[]= new float[640*480];
float dz_dx[]= new float[640*480];
float dz_dy[]= new float[640*480];

void setup() {
  size(640, 480);
  for (int i = 0;i < N;i ++) {
    cells[i]= new Cell();
    cells[i].cd = i;
    cells[i].x = random(320)+160;
    cells[i].y = random(240)+120;
    float dx = cells[i].x-320;
    float dy = cells[i].y-240;
    float dr = sqrt(dx*dx+dy*dy);
    dx = dx/dr*1;
    dy = dy/dr*1;
    cells[i].vx = -dy;
    cells[i].vy = dx;
    cells[i].r = 40;
  }
  for (int y = 0;y < 480;y ++) {
    for (int x = 0;x < 640;x ++) {
      int i = y*604+x;
      z[i]= dz_dt[i]= dz_dx[i]= dz_dy[i]= 0;
    }
  }
  z[320]=10;
}

void wave() {
  // 1階微分
  for (int y = 0;y < 480;y ++) {
    for (int x = 0;x < 640;x ++) {
      int r = (x+1)%640;
      int l = (x-1+640)%640;
      int t = (y+1)%480;
      int b = (y-1+480)%480;
      dz_dx[y*640+x] = z[y*640+r]-2*z[y*640+x]+z[y*640+l];
      dz_dy[y*640+x] = z[b*640+x]-2*z[y*640+x]+z[t*640+x];
      dz_dt[y*640+x] += (dz_dx[y*640+x] + dz_dy[y*640+x]);
      dz_dt[y*640+x] += -z[y*640+x] * 0.1;
    }
  }
  for (int y = 0;y < 480;y ++) {
    for (int x = 0;x < 640;x ++) {
      z[y*640+x] += dz_dt[y*640+x] * 0.01;
      dz_dt[y*640+x] *= 0.98;
    }
  }
}

void draw() {
  for (int i = 0;i < N;i ++) {
    for (int j = 0;j < N;j ++) {
      if (i != j) {
        float ax = cells[i].x-cells[j].x;
        float ay = cells[i].y-cells[j].y;
        float ar = sqrt(ax*ax+ay*ay);
        float d = 1/(ar*ar) * 0.1;
        cells[i].vx -= ax*d;
        cells[i].vy -= ay*d;
      }
    }
    cells[i].x += cells[i].vx;
    cells[i].y += cells[i].vy;
    int cx = int(cells[i].x);
    int cy = int(cells[i].y);
    if (0 <= cx && cx < 640 && 0 <= cy && cy < 480) {
      z[cy*640+cx]= 100;
    }
  }
  wave();
  loadPixels();
  for (int y = 0;y < 480;y ++) {
    for (int x = 0;x < 640;x ++) {
      pixels[y*640+x]= color(z[y*640+x]+128);
    }
  }
  updatePixels();
  noStroke();
  for (int i = 0;i < N;i ++) {
    ellipse(cells[i].x, cells[i].y, 3, 3);
  }
}