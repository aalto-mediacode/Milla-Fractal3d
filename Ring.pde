class Ring {
  float x, y, size, angle, r;
  color col;

  Ring(float radius, float size) {
    this.angle = random(0, 2 * PI);
    this.r = radius;
    this.x = radius * cos(angle);
    this.y = radius * sin(angle);
    this.size = size;
    this.col = color(255);
  }

  void colour() {
    this.col = color(abs(noise(x * 0.01, y * 0.01, time)) * 255 + 70,
      abs(noise(x * 0.005, y * 0.005, time)) * 255 + 30,
      abs(noise(x * 0.02, y * 0.02, time)) * 255 + 70);
  }

  void display() {
    float diameter = 2*r;
    noFill();
    stroke(this.col);
    strokeWeight(this.size);
    circle(0, 0, diameter);
  }
}
