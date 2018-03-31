class Network {

  Neuron [] input_layer;
  Neuron [] hidden_layer;
  Neuron [] output_layer;
  int bestIndex = 0;

Network(int inputs, int hidden, int outputs) {

  input_layer = new Neuron [inputs]; //196 Input Neurons (14x14)
  hidden_layer = new Neuron [hidden]; // 49 hidden Neurons (7x7)
  output_layer = new Neuron [outputs]; //10 Output Neurons 

  for (int i = 0; i < input_layer.length; i++) { //196
    input_layer[i] = new Neuron(); //No weights, inputs or outputs pre-set. 
  }
  
  // Create connection between input and hidden layer 
  for (int j = 0; j < hidden_layer.length; j++) { //49
    hidden_layer[j] = new Neuron(input_layer); //
  }
  
  // Create connection between hidden and output layer 
  for (int k = 0; k < output_layer.length; k++) { //10
    output_layer[k] = new Neuron(hidden_layer);
  }
}

void respond(Card card) {
  for (int i = 0; i < input_layer.length; i++) { //196 Neurons
    input_layer[i].output = card.inputs[i]; //Set output of the input layer to pixel values.
  }
  for (int j = 0; j < hidden_layer.length; j++) { //49 Neurons
    hidden_layer[j].respond();
  }
  for (int k = 0; k < output_layer.length; k++) { //10 Neurons
    output_layer[k].respond();
  }
}

void train(float [] outputs) { //Training set output for specific card 
  // adjust the output layer
  for (int k = 0; k < output_layer.length; k++) { 
    output_layer[k].setError(outputs[k]); //For each neurons in output layer, set error value for each neurons.
    output_layer[k].train(); //Train that specific output neurons 
  }
  
  float best = -1.0;
  for (int i = 0; i < output_layer.length; i++) {
    if (output_layer[i].output > best) bestIndex = i; //Choose the neuron with highes probability. 
  }
  // propagate back to the hidden layer
  for (int j = 0; j < hidden_layer.length; j++) {
    hidden_layer[j].train();
  }
  // The input layer doesn't learn: it is the input and only that
}

void display() {
  drawCon();
  // Draw the input layer
  for (int i = 0; i < input_layer.length; i++) {
    pushMatrix();
    translate(
      (i%14) * height / 20.0 + width * 0.05, 
      (i/14) * height / 20.0 + height * 0.13);
    input_layer[i].display();
    popMatrix();
  }

  // Draw the hidden layer
  for (int j = 0; j < hidden_layer.length; j++) {
    pushMatrix();
    translate(
      (j%7) * height / 20.0 + width * 0.53, 
      (j/7) * height / 20.0 + height * 0.32);
    hidden_layer[j].display();
    popMatrix();
  }

  // Draw the output layer
  float [] resp = new float [output_layer.length];
  float respTotal = 0.0;
  for (int k = 0; k < output_layer.length; k++) {
    resp[k] = output_layer[k].output;
    respTotal += resp[k]+1;
  }
  for (int k = 0; k < output_layer.length; k++) {
    pushMatrix();
    translate(
      width * 0.85, 
      (k%10) * height / 15.0 + height * 0.2);
    output_layer[k].display();
    fill(150);
    strokeWeight(sq(output_layer[k].output)/2);
    line(12, 0, 25, 0);
    text(k%10, 40, 5);
    text(nfc(((output_layer[k].output+1)/respTotal)*100, 2) + "%", 55, 5);
    popMatrix();
    strokeWeight(1);
  }

  float best = -1.0;
  for (int i =0; i < resp.length; i++) {
    if (resp[i]>best) {
      best = resp[i];
      bestIndex = i;
    }
  }
  stroke(255, 0, 0);
  noFill();
  
  ellipse(
    width * 0.85, (bestIndex%10) * height / 15.0 + height * 0.2, 
    25, 25);
}


void drawCon() { //Drawing connection
  for (int i = 0; i < hidden_layer.length; i++) {
      float [] res = hidden_layer[i].getStrength();

      stroke(230);
      strokeWeight(pow(10, res[1])/35);
      
      if (pow(10, res[1])/35 > 5){
          strokeWeight(5);
      }
      
      line(
        (i%7) * height / 20.0 + width * 0.53, 
        (i/7) * height / 20.0 + height * 0.32, 
        (int(res[0])%14) * height / 20.0 + width * 0.05, 
        (int(res[0])/14) * height / 20.0 + height * 0.13);
  }

  for (int i = 0; i < output_layer.length; i++) { //10 times
    for (int j = 0; j <output_layer[i].weights.length; j++){
      float weights = output_layer[i].weights[j];
      
      if (weights > 0){
        stroke(0,weights*200,0);
      }else{
        stroke(150,0,0);
      }
      
      //float [] res = output_layer[i].getStrength();

      //stroke(weights*200);
      strokeWeight(pow(10, weights)/35);
      if (pow(10, weights)/35 > 5){
          strokeWeight(5);
      }
   
      line(
        width * 0.85, 
        (i%10) * height / 15.0 + height * 0.2, 
        (j%7) * height / 20.0 + width * 0.53, 
        (j/7) * height / 20.0 + height * 0.32);
    }
    strokeWeight(1);
    }
}}
