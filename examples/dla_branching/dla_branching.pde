
/////////////////////////////////////////////////
//                                             //
//  Diffusion Limited Aggregation + Branching  //
//                                             //
/////////////////////////////////////////////////

// (c) 2013 by Martin Schneider >>> @bitcraftlab

// This sketch shows how to use the canvascam library,
// to let the user explore the canvas.

// Right Mouse Button and mouse wheel to zoom and move around
// Left Mouse Button to create aggregation points

// In this sketch several particles are floating around
// The number of particles generated stays constant:
// Whenever a particle is frozen a new one
// is emitted from the particle source
// However the process may come to a halt when all locations
// of the particle source are covered with frozen particles


//////////////////////// KEY CODES ///////////////////////

// [s] select particle source
// [n] neighborhood (von Neumann vs Manhattan)

// [c] reset camera
// [+] and [-] to zoom 

//////////////////////////////////////////////////////////


// canvascam is similar to peasycam but for the 2D canvas
import bitcraftlab.canvascam.*;

Grid grid;
Particles particles;
CanvasCam cam;

// steps per frame
int steps = 5;

// minimum size of a cell in pixels
int cellSize = 3;

void setup() {
  
  size(480, 480);
  
  cam = new CanvasCam(this, cellSize);
  int n = int(width / cam.zoom * height / cam.zoom / cellSize);
  
  grid = new Grid();
  particles = new Particles();
  for(int i = 0; i < n; i++) {
    particles.create();
  }
  
}

void draw() {
  
  // move particles
  for(int i = 0; i < steps; i++) {
    for(Particle p : particles) p.move();
  }

  // draw the grid
  grid.draw();
  
  //if(frameCount % 30 == 0) println(particles.size() + " " + (w * h));
}


///// interaction //////

void mousePressed() {
  if (mouseButton == LEFT) {
    grid.mouseMark();
  }
}

void mouseDragged() {
  if (mouseButton == LEFT) {
    grid.mouseMark();
  }
}

void keyPressed() {
  switch(key) {
    case ' ': reset();  break;
    case 'n': reset(); grid.nextHood();  break;
    case 's': particles.nextSource(); reset();  break;
    case '+': cam.zoomBy(sqrt(2)); break;
    case '-': cam.zoomBy(1.0 / sqrt(2)); break;
    case 'c': cam.reset(); break;
   }
}

void reset() {
  particles.reset();
  grid.reset();
  cam.reset();
}



  
  
  
