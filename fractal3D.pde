import peasy.*;

int dim = 120;
PeasyCam cam;

ArrayList<MandelPoint> mandelbulb = new ArrayList<MandelPoint>();
ArrayList<Particle> particles = new ArrayList<Particle>();
ArrayList<Particle> particles2 = new ArrayList<Particle>();
ArrayList<Particle> particles3 = new ArrayList<Particle>();
ArrayList<CircleParticle> cParticles = new ArrayList<CircleParticle>();
ArrayList<Ring> rings = new ArrayList<Ring>();

int maxiterations = 12;
int particleAmount = 3000;
int radius = 3;
boolean noise = true;

void setup() {
  // size(1280, 720, P3D); 

  size(600, 600, P3D);
  cam = new PeasyCam(this, 800);

  // creating particles
  for (int i = 0; i < particleAmount; i++) {
    particles.add(new Particle(random(1, 10), random(1, 10), random(1, 50)));
  }

  for (int i = 0; i < particleAmount; i++) {
    particles2.add(new Particle(random(400, 410), random(-350, -360), random(-1, 100)));
  }

  for (int i = 0; i < particleAmount; i++) {
    particles3.add(new Particle(random(-400, -410), random(400, 410), random(-1, 100)));
  }

  for (int i = 0; i < 2000; i++) {
    cParticles.add(new CircleParticle(random(300, 350)));
  }

  for (int i = 0; i < 1000; i++) {
    cParticles.add(new CircleParticle(random(350, 380)));
  }

  for (int i = 0; i < 1000; i++) {
    cParticles.add(new CircleParticle(random(270, 300)));
  }
  // creating rings
  for (int i = 0; i < 20; i++) {
    rings.add(new Ring(random(270, 380), random(1, 3)));
  }

  // fractal
  for (int i = 0; i < dim; i++) {
    for (int j = 0; j < dim; j++) {

      boolean edge = false;
      int lastIteration = 0;

      for (int k = 0; k < dim; k++) {
        float x = map(i, 0, dim, -1, 1);
        float y = map(j, 0, dim, -1, 1);
        float z = map(k, 0, dim, -1, 1);

        PVector zeta = new PVector(0, 0, 0);
        int n = 16;
        int iteration = 0;

        while (true) {
          Spherical c = spherical(zeta.x, zeta.y, zeta.z);
          float newx = pow(c.r, n) * sin(c.theta*n) * cos(c.phi*n);
          float newy = pow(c.r, n) * sin(c.theta*n) * sin(c.phi*n);
          float newz = pow(c.r, n) * cos(c.theta*n);

          zeta.x = newx + x;
          zeta.y = newy + y;
          zeta.z = newz + z;

          if (c.r > 3) {
            lastIteration = iteration;
            if (edge) {
              edge = false;
            }
            break;
          }

          if (iteration > maxiterations) {
            if (!edge) {
              edge = true;
              mandelbulb.add(new MandelPoint(new PVector(x*200, y*200, z*200), lastIteration));
            }
            break;
          }
          iteration++;
        }
      }
    }
  }
}

// transformation to spherical coordinate system
Spherical spherical(float x, float y, float z) {
  float r = sqrt(x*x + y*y+ z*z);
  float theta = atan2(sqrt(x*x+ y*y), z);
  float phi = atan2(y, x);
  return new Spherical(r, theta, phi);
}

float time = 0;
int alpha = 20, delta = 1;

void draw() {
  background(0);

  // draw background
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {

      float opacity = 0;
      opacity = alpha / 3;

      // Calculate noise, scale by 255, tweak values
      float red = noise(x * 0.008 + time, y * 0.008, time) * 255 - 60 - (opacity / 2);
      float green = noise(x* 0.005 + time, y * 0.005, time) * 255 - 90 - (opacity / 2);
      float blue = noise(x* 0.01 + time, y* 0.01, time) * 255 - 30 - (opacity / 2);

      pixels[x + y*width] = color(red, green, blue);
    }
  }
  updatePixels();

  // rotation
  rotateX(PI/9 * time);
  rotateY(PI/12 * time);
  rotateZ(PI/4 * time);

  // change particle opacity
  if (alpha == 0 || alpha == 255)
  {
    delta = -delta;
  }

  alpha += delta;

  // spawn particles
  for (CircleParticle p : cParticles) {
    p.move();
    p.display();
  }

  for (Ring r : rings) {
    r.display();
    r.colour();
  }

  for (Particle p : particles) {
    p.display();
    p.move(alpha);
  }

  for (Particle p : particles2) {
    p.display();
    p.move(alpha);
  }

  for (Particle p : particles3) {
    p.display();
    p.move(alpha);
  }

  // spawn mandelbulb
  boolean first = true;
  MandelPoint firstM = mandelbulb.get(0);
  for (MandelPoint m : mandelbulb) {
    float n = abs(noise(m.v.x * 0.1, m.v.y * 0.1, time)) * 20;
    stroke(abs(noise(m.v.x * 0.01, m.v.y * 0.01, time)) * 255 + 50,
      abs(noise(m.v.x * 0.005, m.v.y * 0.005, time)) * 255 - 90,
      abs(noise(m.v.x * 0.02, m.v.y * 0.02, time)) * 255 + 10);
    strokeWeight(3);

    if (first) {
      point(m.v.x, m.v.y, m.v.z);
      firstM = m;
      first = false;
    } else {
      line(m.v.x + n, m.v.y - n, m.v.z + n, firstM.v.x, firstM.v.y, firstM.v.z);
    }
  }
  time += 0.01;
}
