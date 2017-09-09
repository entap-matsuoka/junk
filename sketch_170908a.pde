
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

void setup() {
  size(640, 480);
  for (int i = 0;i < N;i ++) {
    cells[i]= new Cell();
    cells[i].cd = i;
    cells[i].x = random(640);
    cells[i].y = random(480);
    cells[i].vx = random(100)/50.0-1.0;
    cells[i].vy = random(100)/50.0-1.0;
    cells[i].r = 40;
  }
  cells[0].x = 100;
  cells[0].y = 100;
  cells[1].x = 200;
  cells[1].y = 100;
}

int[] labels = new int[640*480];

void sep(Cell[] cells, int rx, int ry, int rw, int rh) {
  if (rw<rh) {
    sepH(cells, rx, ry, rw, rh);
  } else {
    sepV(cells, rx, ry, rw, rh);
  }
}

void sepH(Cell[] cells, int rx, int ry, int rw, int rh) {
  if (cells.length == 0) {
  } else if (cells.length == 1) {
    rw = min(max(rx+rw, 0), 640)-rx;
    rh = min(max(ry+rh, 0), 480)-ry;
    rx = min(max(rx, 0), 640);
    ry = min(max(ry, 0), 480);
    
    for (int y = 0;y < rh;y ++) {
      for (int x = 0;x < rw;x ++) {
        labels[(ry+y)*640+(rx+x)]= cells[0].cd;
      }
    }
  } else {
    int mid = 0;
    for (int i = 0;i < cells.length;i ++) {
      mid += cells[i].y - ry;
    }
    mid = mid/cells.length + ry;
    
    // 上に所属するセル数
    int n = 0;
    for (int i = 0;i < cells.length;i ++) {
      if (cells[i].y < mid) {
        n++;
      }
    }
    
    if (n == 0 || n == cells.length) {
      return;
    }
    
    // セルを上下に分ける
    Cell[] cells0 = new Cell[n];
    Cell[] cells1 = new Cell[cells.length-n];
    int i0 = 0, i1 = 0;
    for (int i = 0;i < cells.length;i ++) {
      if (cells[i].y < mid) {
        cells0[i0++]= cells[i];
      } else {
        cells1[i1++]= cells[i];
      }
    }
    sep(cells0, rx, ry, rw, mid - ry);
    sep(cells1, rx, mid, rw, rh - (mid - ry));
  }
}

void sepV(Cell[] cells, int rx, int ry, int rw, int rh) {
  if (cells.length == 0) {
  } else if (cells.length == 1) {
    rw = min(max(rx+rw, 0), 640)-rx;
    rh = min(max(ry+rh, 0), 480)-ry;
    rx = min(max(rx, 0), 640);
    ry = min(max(ry, 0), 480);
    for (int y = 0;y < rh;y ++) {
      for (int x = 0;x < rw;x ++) {
        labels[(ry+y)*640+(rx+x)]= cells[0].cd;
      }
    }
  } else {
    int mid = 0;
    for (int i = 0;i < cells.length;i ++) {
      mid += cells[i].x - rx;
    }
    mid = mid/cells.length + rx;
    
    // 左に所属するセル数
    int n = 0;
    for (int i = 0;i < cells.length;i ++) {
      if (cells[i].x < mid) {
        n++;
      }
    }
    
    if (n == 0 || n == cells.length) {
      return;
    }
    
    // セルを上下に分ける
    Cell[] cells0 = new Cell[n];
    Cell[] cells1 = new Cell[cells.length-n];
    int i0=0,i1=0;
    for (int i = 0;i < cells.length;i ++) {
      if (cells[i].x < mid) {
        cells0[i0++]= cells[i];
      } else {
        cells1[i1++]= cells[i];
      }
    }
    sep(cells0, rx, ry, mid - rx, rh);
    sep(cells1, mid, ry, rw - (mid - rx), rh);
  }
}
void draw() {
  background(255);
  for (int i = 0;i < N;i ++) {
    for (int j = 0;j < N;j ++) {
      if (i != j) {
        float ax = cells[i].x-cells[j].x;
        float ay = cells[i].y-cells[j].y;
        float ar = sqrt(ax*ax+ay*ay);
        float d = 1/(ar*ar);
        cells[i].vx -= ax*d;
        cells[i].vy -= ay*d;
      }
    }
    /*
    cells[i].vx *= 0.98;
    cells[i].vy *= 0.98;*/
    cells[i].x += cells[i].vx;
    cells[i].y += cells[i].vy;
  }
//  sep(cells, 0, 0, 640, 480);
  for (int y = 0;y < 480;y ++) {
    for (int x = 0;x < 640;x ++) {
      float minR = 1000000;
      int minLabel = 0;
      for (int i = 0;i < N;i ++) {
        float dx = x-cells[i].x;
        float dy = y-cells[i].y;
        float dr = dx*dx+dy*dy;
        if (dr < minR) {
          minR = dr;
          minLabel = i;
        }
      }
      labels[y*640+x]= minLabel;
    }
  }
  loadPixels();
  for (int y = 0;y < 480;y ++) {
    for (int x = 0;x < 640;x ++) {
      int lbl = labels[y*640+x];
      pixels[y*640+x]= color(lbl%10*10+150, lbl/10*10+150, 255);
    }
  }
  updatePixels();
  noStroke();
  for (int i = 0;i < N;i ++) {
    ellipse(cells[i].x, cells[i].y, 3, 3);
  }
  saveFrame("frames/######.tif");
}