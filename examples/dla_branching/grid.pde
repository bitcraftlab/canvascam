
//////////////////////////////////////////////////////////
//                                                      //
//                  Cartesian Grid                      //
//                                                      //
//////////////////////////////////////////////////////////

// We use a grid:
//
// 1. for collision detection
// 2. for drawing aggregated particles + branching structures

class Grid {
  
  // dimensions of the grid
  int w, h;
  
  // states: living or dead cell and background
  static final int DEAD = -1, BG = 0, LIVE = 1;
  
  // colors: gray, white, red
  final color[] PALETTE = { #cccccc,  #ffffff, #ff0000 };
  
  // possible neighborhoods
  final int[][][] HOODS = {
    {{0, 0}, {-1,0}, {0,-1}, {+1,0}, {0,+1}},                                      // Manhattan-Neighborhood
    {{0, 0}, {-1,0}, {-1,-1}, {0,-1}, {+1, -1}, {+1,0}, {+1,+1}, {0,+1}, {-1, +1}} // Von Neumann-Neighborhood
  };
  
  int selectHood = 0;

  int[][] grid;
  int[][] angles;
  int[][] HOOD;
  
  Grid() {
    w = int(cam.width);
    h = int(cam.height);
    grid = new int[w][h];
    angles = new int[w][h];
    nextHood();
    reset();
  }
  
  void nextHood() {
    HOOD = HOODS[selectHood++ % 2];
  }
  
  // return a random direction (except the 1st one which should be {0, 0})
  int getRandomDir() {
    return 1 + floor(random(HOOD.length-1));
  }
  
  int getDirX(int dir) {
    return HOOD[dir][0]; 
  }
  
  // get Y component of the direction
  int getDirY(int dir) {
    return HOOD[dir][1];
  }
  
  // mark state of a field
  void mark(int x, int y, int state) {
    grid[x][y] = state;
  }
  
  // mark state and angle of a field
  void mark(int x, int y, int state, int ang) {    
    mark(x, y, state);
    if (angles[x][y] == 0) angles[x][y] = ang;
  }
  
  // get the state of the field
  int getState(int x, int y) {
    return grid[x][y];
  }

  // mark the field at the mouse position as dead
  void mouseMark() {
    int x = cam.mouseX;
    int y = cam.mouseY;
    if(x >= 0 && x < w && y >= 0 && y < h) {
      mark(x, y, DEAD);
    }
  }


  void draw() {
    
    background(255);    

    // draw all the boxes
    noSmooth();

    for(int i = 0, n = w*h; i < n; i++) {
      int idx = getState(i%w, i/w);
      color c = PALETTE[idx + 1];
      fill(c);
      noStroke();
      rect(i%w , i/w, 1, 1);
    }
       
    // draw all the lines
    stroke(0);
    translate(.5, .5);
    cam.strokeWeight(1.0);
    
    smooth();
    
    for(int x = 0; x < w; x++) {
      for(int y = 0; y < h; y++) {
        int s = grid[x][y];
        int idx = angles[x][y];
        int[] dir = HOOD[idx];
        int dx = dir[0];
        int dy = dir[1];
        if(s == DEAD) {
          line(x, y, x + dx, y + dy); 
        }
      }
    }

  }
  
  // reset states and angles of all fields
  void reset() {
    for(int x = 0; x < w; x++) {
      for(int y = 0; y < h; y++) {
        grid[x][y] = BG;
        angles[x][y] = 0;
      }
    }
  }
  
}
