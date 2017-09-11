
class Cell {
  public int cd;
  public float x;
  public float y;
  public float r;
  public float vx;
  public float vy;
}

PImage img;

int N = 20;
Cell cells[] = new Cell[N];

float z[]= new float[640*480];
float dz_dt[]= new float[640*480];
float dz_dx[]= new float[640*480];
float dz_dy[]= new float[640*480];
float dz_ddx[]= new float[640*480];
float dz_ddy[]= new float[640*480];

void setup() {
  size(640, 480);
  for (int i = 0;i < N;i ++) {
    cells[i]= new Cell();
    cells[i].cd = i;
    cells[i].x = random(200)+270;
    cells[i].y = random(200)+140;
    float dx = cells[i].x-320;
    float dy = cells[i].y-240;
    float dr = sqrt(dx*dx+dy*dy);
    dx = dx/dr*2;
    dy = dy/dr*2;
    cells[i].vx = -dy;
    cells[i].vy = dx;
    cells[i].r = 40;
  }
  for (int y = 0;y < 480;y ++) {
    for (int x = 0;x < 640;x ++) {
      int i = y*640+x;
      z[i]= dz_dt[i]= dz_ddx[i]= dz_ddy[i]=dz_dx[i]= dz_dy[i]= 0;
    }
  }
  img = loadImage("bg.jpg");
  img.loadPixels();
}

void wave() {
  // 1階微分
  for (int y = 0;y < 480;y ++) {
    for (int x = 0;x < 640;x ++) {
      int r = (x+1)%640;
      int l = (x-1+640)%640;
      int t = (y+1)%480;
      int b = (y-1+480)%480;
      dz_ddx[y*640+x] = z[y*640+r]-2*z[y*640+x]+z[y*640+l];
      dz_ddy[y*640+x] = z[b*640+x]-2*z[y*640+x]+z[t*640+x];
      dz_dx[y*640+x] = z[y*640+r]-z[y*640+l];
      dz_dy[y*640+x] = z[b*640+x]-z[t*640+x];
      dz_dt[y*640+x] += (dz_ddx[y*640+x] + dz_ddy[y*640+x]);
      dz_dt[y*640+x] += -z[y*640+x] * 0.1;
    }
  }
  for (int y = 0;y < 480;y ++) {
    for (int x = 0;x < 640;x ++) {
      z[y*640+x] += dz_dt[y*640+x] * 0.2;
      dz_dt[y*640+x] *= 0.99;
    }
  }
}

void drop(int x, int y, int r, int p) {
  
    for (int a= 0;a<r;a++) {
      for (int b= 0;b<r;b++) {
        int cx = x+a;
        int cy =y+b;
        int rr = a*a+b*b;
        if (rr<r*r) {
          if (0 <= cx && cx < 640 && 0 <= cy && cy < 480) {
            z[cy*640+cx]= p+sqrt(r*r-rr);
          }
        }
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
        float d = 1/(ar*ar) * 0.5;
        cells[i].vx -= ax*d;
        cells[i].vy -= ay*d;
      }
    }
    cells[i].x += cells[i].vx;
    cells[i].y += cells[i].vy;
    int cx0 = int(cells[i].x);
    int cy0 = int(cells[i].y);
    drop(cx0, cy0, 5, 100);
    if (cells[i].x<0) {
      cells[i].x+=640;
    }
    if (cells[i].x>=640) {
      cells[i].x-=640;
    }
    if (cells[i].y<0) {
      cells[i].y+=480;
    }
    if (cells[i].y>=480) {
      cells[i].y-=480;
    }
  }
  wave();
  loadPixels();
  for (int y = 0;y < 480;y ++) {
    for (int x = 0;x < 640;x ++) {
      int px = (int)(dz_dx[y*640+x]*0.1);
      int py = (int)(dz_dy[y*640+x]*0.1);
      int inte = (int)(sqrt(px*px+py*py));
      px += x+20;
      py += y+20;
      px = (px+img.width*1000)%img.width;
      py = (py+img.height*1000)%img.height;
      color c = img.pixels[py*img.width+px];
      c = color(red(c)+inte, green(c)+inte, blue(c)+inte);
      pixels[y*640+x]= c;
    }
  }
  updatePixels();
  noStroke();
  for (int i = 0;i < N;i ++) {
    float speed = cells[i].vx*cells[i].vx+cells[i].vy*cells[i].vy;
    speed = sqrt(speed);
    fill(255);//,120,140);//speed*100, speed*120, speed*140);
    //float r = sqrt(speed);
    ellipse(cells[i].x, cells[i].y, 3, 3);//r, r);
  }
  saveFrame("frames/#####.tif");
}