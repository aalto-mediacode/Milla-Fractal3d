class Particle {
  float x, y, z, size, speed, n;
  color col;

  Particle(float x, float y, float z) {
    this.n = noise(this.x * 0.03, this.y * 0.03, this.z * 0.03);
    this.x = x;
    this.y = y;
    this.z = z;
    this.size = 3;
    this.speed = random(-15, 15);
    this.col = color(255, 255, 255, 0);
  }

  void move(float opacity) {
    float n = noise(this.x * 0.03, this.y * 0.03, this.z * 0.03);

    this.x += cos(n * 3 * PI) * this.speed;
    this.y += sin(n * 3 * PI) * this.speed;
    this.z += cos(n * 3 * PI) * this.speed;

    this.col = color(abs(noise(x * 0.01, y * 0.01, time)) * 255 + 120,
      abs(noise(x * 0.005, y * 0.005, time)) * 255 + 40,
      abs(noise(x * 0.02, y * 0.02, time)) * 255 + 100, opacity);
  }

  void display() {
    stroke(this.col);
    strokeWeight(this.size);
    point(this.x, this.y, this.z);
  }
}
