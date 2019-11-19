color aliveCell = color(235, 69, 0); //<>//
color deadCell = color(255);
int value = 0;
int arraySize = 100;
boolean[][] generation1;
boolean[][] generation2 = new boolean[arraySize][arraySize];
boolean playing = true;
boolean colorGradient = true;

void setup() {
  size(1000, 1000);
  frameRate(15);
  surface.setTitle("Conway's game of life");
  generation1 = generateEmpty();
  //generation1 = generate();
  ellipseMode(CENTER);
  //init();
}

void draw() {
  background(deadCell);
  stroke(aliveCell);
  display();

  if (mousePressed == true) {
    if (mouseButton == LEFT) {
      if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
        generation1[int(mouseX/10)][int(mouseY/10)] = true;
      }
    } else if (mouseButton == RIGHT) {
      if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
        generation1[int(mouseX/10)][int(mouseY/10)] = false;
      }
    }
  }

  if (playing == true) {
    changeGeneration();
  }
  fill(aliveCell);
  ellipse(width/2, height/2, 5, 5);
}

boolean[][] generate() {
  boolean[][] tableau = new boolean[arraySize][arraySize];
  for (int y = 0; y < tableau.length; y++) {
    for (int x= 0; x < tableau[0].length; x++) {
      int randomized = int(random(0, 5));
      if (randomized == 1) {
        tableau[x][y] = true;
      }
    }
  }
  return tableau;
}

boolean[][] generateEmpty() {
  boolean[][] tableau = new boolean[arraySize][arraySize];
  for (int y = 0; y < tableau.length; y++) {
    for (int x= 0; x < tableau[0].length; x++) {
      tableau[x][y] = false;
    }
  }
  return tableau;
}

void changeGeneration() {
  int[] coordsCell = new int[2];
  for (int y = 0; y < generation2.length; y++) {
    for (int x= 0; x < generation2[0].length; x++) {
      coordsCell[0] = x;
      coordsCell[1] = y;
      generation2[x][y] = checkAlive(coordsCell);
    }
  }
  generation1 = generation2;
  generation2 = generateEmpty();
}

boolean checkAlive(int[] coords) {
  boolean alive = false;
  int neighboursAlive = 0;

  if (coords[0] > 0) {
    if (coords[1] > 0 && generation1[coords[0]-1][coords[1]-1] == true) {
      neighboursAlive++;
    }

    if (coords[1] < generation1.length-1 && generation1[coords[0]-1][coords[1]+1] == true) {
      neighboursAlive++;
    }

    if (generation1[coords[0]-1][coords[1]] == true) {
      neighboursAlive++;
    }
  }

  if (coords[0] < generation1.length-1) {
    if (coords[1] > 0 && generation1[coords[0]+1][coords[1]-1] == true) {
      neighboursAlive++;
    }

    if (coords[1] < generation1.length-1 && generation1[coords[0]+1][coords[1]+1] == true) {
      neighboursAlive++;
    }
    if (generation1[coords[0]+1][coords[1]] == true) {
      neighboursAlive++;
    }
  }

  if (coords[1] > 0) {
    if (generation1[coords[0]][coords[1]-1] == true) {
      neighboursAlive++;
    }
  }

  if (coords[1] < generation1.length-1) {
    if (generation1[coords[0]][coords[1]+1] == true) {
      neighboursAlive++;
    }
  }

  if (neighboursAlive == 3) {
    alive = true;
  } else if (neighboursAlive == 2) {
    alive = generation1[coords[0]][coords[1]];
  } else if (neighboursAlive < 2 || neighboursAlive > 3) {
    alive = false;
  }

  return alive;
}

void display() {
  for (int y = 0; y < generation1.length; y++) {
    for (int x= 0; x < generation1[0].length; x++) {
      color aliveCell2 = color(red(aliveCell)+y+x-75, green(aliveCell)+y+x-75, blue(aliveCell)+y+x-75);
      if (generation1[x][y] == true) {
        fill(aliveCell2);
        rect(x*10, y*10, 10, 10);
      } else {
        fill(deadCell);
        rect(x*10, y*10, 10, 10);
      }
    }
  }
}

void keyPressed() {
  if (value == 0) {
    if (key == ' ') {
      if (playing == false) {
        playing = true;
      } else {
        playing = false;
      }
    } else if (key == 'e') {
      generation1 = generateEmpty();
      generation2 = generateEmpty();
    } else if (key == 's') {
      selectOutput("Select a file to write to:", "outputFileSelected");
    } else if (key == 'l') {
      selectInput("Select a file to process:", "inputFileSelected");
    } else if (key == 'r') {
      generation1 = generate();
    }
    value = 255;
  } else {
    value = 0;
  }
}

void inputFileSelected(File selection) {
  if (selection != null) {
    loadState(selection.getAbsolutePath());
  }
}

void loadState(String statePath) {
  String[] loadingArray = loadStrings(statePath);
  for (int y = 0; y < generation1.length; y++) {
    for (int x= 0; x < generation1[0].length; x++) {
      if (loadingArray[y].charAt(x) == '0') {
        generation1[x][y] = false;
      } else {
        generation1[x][y] = true;
      }
    }
  }
  println("Successfully loaded structure : " + statePath);
}

void outputFileSelected(File selection) {
  if (selection != null) {
    saveState(selection.getAbsolutePath());
  }
}

void saveState() {
  String[] savingArray = new String[generation1.length];
  for (int i = 0; i < savingArray.length; i++) {
    savingArray[i] = "";
  }

  for (int y = 0; y < generation1.length; y++) {
    for (int x= 0; x < generation1[0].length; x++) {
      if (generation1[x][y] == false) {
        savingArray[y] += "0";
      } else {
        savingArray[y] += "1";
      }
    }
  }
  saveStrings("savedStructures/structure" + int(random(0, 50000)) + ".txt", savingArray);
  println("Successfully saved structure");
}

void saveState(String path) {
  String[] savingArray = new String[generation1.length];
  for (int i = 0; i < savingArray.length; i++) {
    savingArray[i] = "";
  }

  for (int y = 0; y < generation1.length; y++) {
    for (int x= 0; x < generation1[0].length; x++) {
      if (generation1[x][y] == false) {
        savingArray[y] += "0";
      } else {
        savingArray[y] += "1";
      }
    }
  }

  saveStrings(path, savingArray);
  println("Successfully saved structure");
}
