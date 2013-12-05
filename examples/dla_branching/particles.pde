
//////////////////////////////////////////////////////////
//                                                      //
//                   DLA Particles                      //
//                                                      //
//////////////////////////////////////////////////////////

// A list of particles, with  methods to create new ones etc.
class Particles extends ArrayList<Particle> {
  
  int selectParticleSource = 1;
  
  // recreate all particles
  void reset() {
    for(Particle p : this) create(p);
  }
  
  // create new particle at a random position
  void create() {
    Particle p = new Particle();
    add(p);
    create(p);
  }
  
  // pick the next particle source
  void nextSource() {
     selectParticleSource++; 
  }
  
  // create a new particle, reusing an old one
  void create(Particle p) {
    
    switch(selectParticleSource % 2) {
      
      case 0: 
        p.x = floor(random(grid.w - 1));
        p.y = floor(random(grid.h - 1));
        break;
        
      case 1:
        float ang = random(TWO_PI);
        int r = grid.w/3;
        int x =
        p.x = grid.w/2 + int(r * cos(ang));
        p.y = grid.w/2 + int(r * sin(ang));
        break;
        
    }

  }

}

// Particles can move around.
// They freeze once they collide with a dead particles.
// (using the grid for collision detection)

class Particle {
  
  int x, y;

  void move() {
    
    // get new positions
    int dir = grid.getRandomDir();
    int dx = grid.getDirX(dir); 
    int dy = grid.getDirY(dir);
    int nx = constrain(x + dx, 0, grid.w-1);
    int ny = constrain(y + dy, 0, grid.h-1);
    
    // look at new positon
    int gs = grid.getState(nx, ny);

    switch(gs) {
      
      case Grid.BG:    // move it
        grid.mark(x, y, Grid.BG);
        x = nx;
        y = ny;
        grid.mark(x, y, Grid.LIVE);
        break;
        
      case Grid.DEAD:  // aggregation
        freeze(dir);
        break;
        
      default:        // don't move, since there is another particle already
        break;
        
    }
  }
  
  // mark pixel as frozen and reuse it
  void freeze(int dir) {
    
    grid.mark(x, y, Grid.DEAD, dir);
    
    // reuse this particle
    particles.create(this);
    
  }
  
}
