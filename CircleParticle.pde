class CircleParticle {
  float x, y, z, size, speed, angle, r;
  color col;

  CircleParticle(float radius) {
    this.r = radius;
    this.x = radius * cos(angle);
    this.y = radius * sin(angle);
    this.z = random(0, 3);
    this.angle = random(0, 2 * PI);
    this.size = 3;
    this.speed = PI / 10;
    this.col = color(255, 255, 255, 0);
  }

  void move() {
    if (angle >= PI * 2) {
      angle = 0;
    };

    this.x = r * cos(angle);
    this.y = r * sin(angle);

    angle += 0.01 * speed;

    this.col = color(abs(noise(x * 0.01, y * 0.01, time)) * 255 + 40,
      abs(noise(x * 0.005, y * 0.005, time)) * 255 + 30,
      abs(noise(x * 0.02, y * 0.02, time)) * 255 + 50);
  }

  void display() {
    stroke(this.col);
    strokeWeight(this.size);
    point(this.x, this.y, this.z);
  }
}
