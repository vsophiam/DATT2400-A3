// Sophia Maxine Villarosa
// 218193631
// DATT 2400 A3 Final Project



Ball ball; // Define the ball as a global object 

Paddle paddleLeft;
Paddle paddleRight;

int scoreLeft = 0;
int scoreRight = 0;
String gameState;
int maxTime;

Timer countDownTimer;
int timeLeft;

void setup(){
  size(800,600);
  
  gameState = "START";
  
  ball = new Ball(width/2, height/2, 50); //create a new ball to the center of the window
  ball.speedX = 5; // Giving the ball speed in x-axis
  ball.speedY = random(-3,3); // Giving the ball speed in y-axis
  
  paddleLeft = new Paddle(15, height/2, 30,200);
  paddleRight = new Paddle(width-15, height/2, 30,200);

countDownTimer = new Timer(1000);
maxTime = 30;
timeLeft = maxTime;

}


void startGame() {
  textAlign(CENTER);
  textSize(20);
  fill(255,0,0);
  text("Click anywhere to play", width/2, height/2-70);
  textSize(20);
  fill(255,0,0);
  text("Player 1: Press S to move paddle up and press Z to move paddle down\n Player 2: Press Up and Down arrow", width/2, height/2-20);
  
  if (mousePressed == true) {
    gameState= "PLAY"; 
    countDownTimer.start();
  }
}
  
  
void draw() {
  
  if (gameState == "START") {
    startGame();
  } else if (gameState == "PLAY") {
    playGame();
    } else if (gameState == "LOSE") {
    winGame();
  }
}  
  
void playGame(){
  background(0); //clear canvas
  ball.display(); // Draw the ball to the window
  ball.move(); //calculate a new location for the ball
  ball.display(); // Draw the ball on the window
  
  paddleLeft.move();
  paddleLeft.display();
  paddleRight.move();
  paddleRight.display();
  
  if(countDownTimer.complete() == true){
    if(timeLeft>0){
      timeLeft--;
      countDownTimer.start();
    } else {
      gameState = "LOSE";
  }
  }

String s = "Time left: " + timeLeft;
textAlign(LEFT);
textSize(14);
fill(255,0,0);
text(s,20,100);

  
  if (ball.right() > width) {
    scoreLeft = scoreLeft + 1;
    ball.x = width/2;
    ball.y = height/2;
  }
  if (ball.left() < 0) {
    scoreRight = scoreRight + 1;
    ball.x = width/2;
    ball.y = height/2;
  }

  if (ball.bottom() > height) {
    ball.speedY = -ball.speedY;
  }

  if (ball.top() < 0) {
    ball.speedY = -ball.speedY;
  }
  
  if (paddleLeft.bottom() > height) {
    paddleLeft.y = height-paddleLeft.h/2;
  }

  if (paddleLeft.top() < 0) {
    paddleLeft.y = paddleLeft.h/2;
  }
    
  if (paddleRight.bottom() > height) {
    paddleRight.y = height-paddleRight.h/2;
  }

  if (paddleRight.top() < 0) {
    paddleRight.y = paddleRight.h/2;
  }
  
  
  // If the ball gets behind the paddle 
  // AND if the ball is in the area of the paddle (between paddle top and bottom)
  // bounce the ball to other direction

  if ( ball.left() < paddleLeft.right() && ball.y > paddleLeft.top() && ball.y < paddleLeft.bottom()){
    ball.speedX = -ball.speedX;
    ball.speedY = map(ball.y - paddleLeft.y, -paddleLeft.h/2, paddleLeft.h/2, -10, 10);
  }

  if ( ball.right() > paddleRight.left() && ball.y > paddleRight.top() && ball.y < paddleRight.bottom()) {
    ball.speedX = -ball.speedX;
    ball.speedY = map(ball.y - paddleRight.y, -paddleRight.h/2, paddleRight.h/2, -10, 10);
  }
  
  
  textSize(40);
  textAlign(CENTER);
  text(scoreRight, width/2+30, 30); // Right side score
  text(scoreLeft, width/2-30, 30); // Left side score
}

void keyPressed(){
  if(keyCode == UP){
    paddleRight.speedY=-5;
  }
  if(keyCode == DOWN){
    paddleRight.speedY=5;
  }
  if(key == 's'){
    paddleLeft.speedY=-5;
  }
  if(key == 'z'){
    paddleLeft.speedY=5;
  }
}

void keyReleased(){
  if(keyCode == UP){
    paddleRight.speedY=0;
  }
  if(keyCode == DOWN){
    paddleRight.speedY=0;
  }
  if(key == 's'){
    paddleLeft.speedY=0;
  }
  if(key == 'z'){
    paddleLeft.speedY=0;
  }
}

void winGame() {
  textAlign(CENTER);
  textSize(25);
  fill(255,0,0);
  text("Game over", width/2, height/2-40);
  textSize(20);
  fill(255,0,0);
  text("Play again?", width/2, height/2-5);
  
  drawReplayButton();
 
}


void resetGame() {
  timeLeft = maxTime;
  countDownTimer.start();
  scoreLeft = 0;
  scoreRight = 0;
}


void drawReplayButton() {
  
  fill(100);
  rect(width/2-50, height/2+80, 100, 60);
  fill (0,255,0);
  textSize(36);
  text("PLAY", width/2, height/2+122);
  
  float leftEdge = width/2-50;
  float rightEdge = width/2 + 50;
  float topEdge = height/2 + 80;
  float bottomEdge = height/2 + 140;
  
  if (mousePressed == true &&
  mouseX > leftEdge &&
  mouseX < rightEdge &&
  mouseY > topEdge &&
  mouseY < bottomEdge 
  ) {

    resetGame();
    gameState = "PLAY";
    
  }
}
  


class Ball {
  float x;
  float y;
  float speedX;
  float speedY;
  float diameter;
  color c;
  
  // Constructor method
  Ball(float tempX, float tempY, float tempDiameter) {
    x = tempX;
    y = tempY;
    diameter = tempDiameter;
    speedX = 0;
    speedY = 0;
    c = (225); 
  }
  
  void move() {
    // Add speed to location
    y = y + speedY;
    x = x + speedX;
  }
  
  void display() {
    fill(c); //set the drawing color
    ellipse(x,y,diameter,diameter); //draw a circle
  }
  
  //functions to help with collision detection
  float left(){
    return x-diameter/2;
  }
  float right(){
    return x+diameter/2;
  }
  float top(){
    return y-diameter/2;
  }
  float bottom(){
    return y+diameter/2;
  }

}



class Paddle{

  float x;
  float y;
  float w;
  float h;
  float speedY;
  float speedX;
  color c;
  
  Paddle(float tempX, float tempY, float tempW, float tempH){
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    speedY = 0;
    speedX = 0;
    c=(255);
  }

  void move(){
    y += speedY;
    x += speedX;
  }

  void display(){
    fill(c);
    rect(x-w/2,y-h/2,w,h);
  } 
  
  //helper functions
  float left(){
    return x-w/2;
  }
  float right(){
    return x+w/2;
  }
  float top(){
    return y-h/2;
  }
  float bottom(){
    return y+h/2;
  }
}

class Timer{
  int startTime;
  int interval;
  
  Timer(int timeInterval) {
    interval = timeInterval;
  }
  
  void start() {
    startTime = millis();
  }
  
  boolean complete() {
    int elapsedTime = millis() - startTime;
    if (elapsedTime > interval) {
      return true;
    } else{
      return false;
    }
  }
}
