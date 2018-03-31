float LEARNING_RATE = 0.01;


class Neuron {

  Neuron [] inputs; // Strores the neurons from the previous layer
  float [] weights;
  float output;
  float error;

  Neuron() {
    error = 0.0;
  }

  Neuron(Neuron [] p_inputs) { //196 neurons connected to single  hiddenneuron 
    inputs = new Neuron [p_inputs.length]; //196 input neurons connected 
    weights = new float [p_inputs.length]; //196 weights connected 
    error = 0.0;
    
    for (int i = 0; i < inputs.length; i++) {  //196
      inputs[i] = p_inputs[i]; //Copy inputs of the previous layer
      weights[i] = random(-1.0, 1.0); //Random weight per connection (196)
    }
  }

  void respond() {  
    float input = 0.0;
    
    for (int i = 0; i < inputs.length; i++) { //196 or 49
      input += inputs[i].output * weights[i]; //Sum up all the output of the connected neurons (196 numbers - pixel value) * weights of that connection 
    }
    output = lookupSigmoid(input); //Go through Sigmoid for activation (-1 to 1)
    error = 0.0;
  }

  void setError(float desired) {
    error = desired - output; //(1 - -1) = 0;  If error rate gets bigger, output value far from the desired value. 
  }

  void train() {
    float delta =(1.0 - output) * (1.0 + output) * error * LEARNING_RATE; // Low (1-output)*(1+output) when wrong. 
    for (int i = 0; i < inputs.length; i++) { //196 or 49 
      inputs[i].error += weights[i] * error; //Error of the previous neurons are added by weights of the connection * error of this neuron. (bigger error means bigger errors in the previous neurons)
      weights[i] += inputs[i].output * delta; //Weights of connections are added by the output of the previous neurons * changes. 
    } //Update errors of the previous neurons and its connection weights based on the error. More error = more changes in weights. 
  }

  void display() {
    stroke(100);
    fill(128 * (1 - output));
    ellipse(0, 0, 16, 16);
  }

  float [] getStrength() {
    float ind = 0.0;
    float str = 0.0;
    
    for (int i = 0; i < weights.length; i++) { //49 
      if (weights[i] > str) {
        ind = i; 
        str = weights[i];
      }
    }
    float [] a = {ind, str}; //Strongest weights passes through. 
    return a;
  }
}
