int totalTrain = 0;
int totalTest = 0;
int totalRight = 0;
float sucess = 0;
int testCard = 0;
int trainCard = 0;

Boolean continuous_train = false;
int FRAME_RATE = 5;

Network neuralnet;

Button trainB, testB, bulkB;


void setup() {

  size(1000, 400); //Window Size 
  setupSigmoid(); //Set up sigmoid function
  loadData(); //Load images and labels 
  
  neuralnet = new Network(196, 49, 10); //Create Neuron objects
  
  smooth();
  stroke(150);
  frameRate(FRAME_RATE);
  
  trainB = new Button(width*0.06, height*0.9, "Train");
  testB = new Button(width*0.11, height*0.9, "Test");
  bulkB = new Button(width*0.16, height*0.9, "Bulk");
}

void train(){
  trainCard = (int) floor(random(0, training_set.length)); //CHoose one card from the training set
  neuralnet.respond(training_set[trainCard]);  //Network respond by computing output from the connections
  neuralnet.train(training_set[trainCard].outputs); //With computed outputs for each neurons in hidden and output neurons, train the system. 
  totalTrain++;
}

void draw() {

  background(30);
  neuralnet.display();
  
  fill(255);
  text("Train card: #" + trainCard + "/ #"+training_set[trainCard].output, width*0.18, height*0.89);
  text("Test card: #" + testCard, width*0.18, height*0.93);
 
  text("Total train: " + totalTrain, width*0.32, height*0.89);
  text("Total test: " + totalTest, width*0.32, height*0.93);
  
  if(totalTest>0) sucess = float(totalRight)/float(totalTest);
  
  text("Success rate: " + nfc(sucess, 2), width*0.44, height*0.89);
  text("Card label: " + testing_set[testCard].output, width*0.44, height*0.93);
  
  trainB.display();
  testB.display();
  bulkB.display();
  
  if (continuous_train){
    train();
  }
}

void mousePressed() {
  if (trainB.hover()) {
    continuous_train = !continuous_train;
  } else if (testB.hover()){
    testCard = (int) floor(random(0, testing_set.length));
    neuralnet.respond(testing_set[testCard]);
    neuralnet.display();
    if(neuralnet.bestIndex == testing_set[testCard].output) totalRight ++;
    totalTest ++;
  } else if(bulkB.hover()){
    for (int i = 0; i<5000; i++){
      trainCard = (int) floor(random(0, training_set.length)); //CHoose one card from the training set
      neuralnet.respond(training_set[trainCard]);  //Network respond by computing output from the connections
      neuralnet.train(training_set[trainCard].outputs); //With computed outputs for each neurons in hidden and output neurons, train the system. 
      totalTrain++;
    }
  }
  redraw();
}
