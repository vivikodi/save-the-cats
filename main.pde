
ArrayList<Cat> cats;

PVector paddlePos;
PVector paddleSize;

PFont arcadeFont;

float speed;
int bounceCount;
boolean playing;



void setup() {
  size(500, 300);

  arcadeFont = createFont("Monospaced", 30, true);

  speed = 3.5;
  bounceCount = 0;
  playing = false;

  paddleSize = new PVector(100, 10);
  paddlePos = new PVector(width / 2, height - 20);

  cats = new ArrayList<Cat>();
  cats.add(new Cat(width / 2, 15, 0, speed));
}


void draw() {
  background(0);

  handleInput();

  if (playing) {
    for (int i = cats.size() - 1; i >= 0; i--) {
      Cat cat = cats.get(i);

      cat.update();
      cat.handleBounce();

      if (cat.pos.y - cat.diameter / 2 > height) {
        playing = false;
        break;
      }
    }

    if (!playing) {
      cats.clear();
    }
  }

  for (Cat cat : cats) {
    cat.drawCat();
  }



  fill(255);
  noStroke();
  rectMode(CENTER);
  rect(paddlePos.x, paddlePos.y, paddleSize.x, paddleSize.y);

  fill(255);
  textFont(arcadeFont);
  textSize(20);
  textAlign(LEFT, TOP);
  text("SCORE: " + bounceCount, 10, 10);

  if (!playing && cats.isEmpty() && bounceCount > 0) {
    textAlign(CENTER, CENTER);

    textSize(30);
    text("GAME OVER", width / 2, height / 2 - 20);

    textSize(12);
    text("CLICK TO RESTART", width / 2, height / 2 + 20);
  } else if (!playing) {
    textAlign(CENTER, CENTER);
    textSize(16);
    text("CLICK TO START", width / 2, height / 2);
  }
}

void handleInput() {
  paddlePos.x = mouseX;


  paddlePos.x = constrain(
    paddlePos.x,
    paddleSize.x / 2,
    width - paddleSize.x / 2
  );
}

void mousePressed() {
  if (!playing) {
    cats.clear();

    bounceCount = 0;
    speed = 3.5;

    paddlePos.x = width / 2;

    cats.add(new Cat(width / 2, 15, 0, speed));

    playing = true;
  }
}

class Cat {
  PVector pos;
  PVector velocity;

  float diameter = 30;

  Cat(float x, float y, float vx, float vy) {
    pos = new PVector(x, y);
    velocity = new PVector(vx, vy);
  }

  void update() {
    pos.add(velocity);
  }

  void handleBounce() {
    float r = diameter / 2;

    if (pos.x - r < 0) {
      pos.x = r;
      velocity.x = abs(velocity.x);
    }

    if (pos.x + r > width) {
      pos.x = width - r;
      velocity.x = -abs(velocity.x);
    }

    if (pos.y - r < 0) {
      pos.y = r;
      velocity.y = abs(velocity.y);
    }

    float paddleLeft = paddlePos.x - paddleSize.x / 2;
    float paddleRight = paddlePos.x + paddleSize.x / 2;
    float paddleTop = paddlePos.y - paddleSize.y / 2;

    if (
      velocity.y > 0 &&
      pos.y + r >= paddleTop &&
      pos.y - r < paddlePos.y + paddleSize.y / 2 &&
      pos.x >= paddleLeft &&
      pos.x <= paddleRight
    ) {
      pos.y = paddleTop - r;

      bounceCount++;

      velocity.y = -abs(velocity.y);

      float hitPosition = pos.x - paddlePos.x;
      velocity.x = hitPosition / 6 + random(-0.3, 0.3);
      velocity.x = constrain(velocity.x, -3, 3);

      if (
        bounceCount == 3 ||
        (bounceCount >= 10 && bounceCount % 10 == 0)
      ) {
        cats.add(
          new Cat(
            random(30, width - 30),
            30,
            random(-1, 1),
            -speed
          )
        );
      }
    }
  }

  void drawCat() {
    pushMatrix();
    translate(pos.x, pos.y);

    float r = diameter / 2;

    noStroke();

    fill(255, 140, 40);

    triangle(
      -r + 2, -r + 10,
      -r + 3, -r - 5,
      -2, -r + 3
    );

    triangle(
      2, -r + 3,
      r - 3, -r - 5,
      r - 2, -r + 10
    );

    fill(255, 140, 40);
    ellipse(0, 0, diameter, diameter);

    fill(245, 175, 180);

    triangle(
      -r + 5, -r + 5,
      -r + 5, -r - 1,
      -5, -r + 5
    );

    triangle(
      5, -r + 5,
      r - 5, -r - 1,
      r - 5, -r + 5
    );

    fill(0);
    ellipse(-5, -2, 3, 5);
    ellipse(5, -2, 3, 5);

    fill(235, 125, 145);
    triangle(-2, 3, 2, 3, 0, 6);

    stroke(0);
    strokeWeight(1);
    line(0, 6, 0, 9);
    line(0, 9, -3, 11);
    line(0, 9, 3, 11);

    line(-8, 5, -14, 3);
    line(-8, 7, -14, 7);
    line(8, 5, 14, 3);
    line(8, 7, 14, 7);

    popMatrix();
  }
}
