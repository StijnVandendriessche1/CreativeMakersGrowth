import processing.core.PApplet;
import processing.core.PShape;
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;

ArrayList<String> fileNames = new ArrayList<String>();
int currentIndex = 0;
String folderPath = "/home/osboxes/Documents/GrowthProject/skeleton/out";  // Specify the folder path
String prefix = "M01";  // Specify the prefix
PShape currentModel;

void setup() {
  size(800, 600, P3D);  // Set up a 3D canvas
  loadFileNames(folderPath);
  if (!fileNames.isEmpty()) {
    println("Loaded " + fileNames.size() + " file names.");
    loadModel(currentIndex);
  } else {
    println("No models found.");
  }
}

void draw() {
  background(255);
  lights();  // Enable lighting
  if (currentModel != null) {
    pushMatrix();
    translate(width / 2, height * 0.85);  // Move the origin downwards
    rotateX(HALF_PI);  // Rotate the model to align with Processing's coordinate system
    rotateZ(frameCount * 0.02);  // Rotate the model (optional)
    scale(3); // Adjust the scale to zoom in
    shape(currentModel);  // Draw the current model
    popMatrix();
  }
  
  // Display file name in the top right corner
  textAlign(RIGHT, BOTTOM);
  fill(0);
  textSize(16);
  String fileName = new File(fileNames.get(currentIndex)).getName(); // Extract file name without path
  fileName = fileName.substring(0, fileName.lastIndexOf('.')); // Remove file extension
  text(fileName, width - 10, height - 10);
  
  // Display additional text in the bottom left corner
  textAlign(LEFT, BOTTOM);
  text("Re-Framed - Creative Makers 2024", 10, height - 10);
  
  //Display names
  textAlign(LEFT, TOP);
  fill(100);
  textSize(12);
  textLeading(12);
  text("Bettini Alessandro\nKrivads Kristaps\nLoos Floor\nVandendriessche Stijn", 10, 10);
}


void loadFileNames(String folderPath) {
  File folder = new File(folderPath);
  File[] files = folder.listFiles();
  
  if (files != null) {
    // Filter and collect files with the specified prefix and date format
    for (File file : files) {
      if (file.isFile() && file.getName().startsWith(prefix) && file.getName().endsWith("_reduced_branches.obj")) {
        fileNames.add(file.getAbsolutePath());
      }
    }
    
    // Sort file names alphabetically
    Collections.sort(fileNames);
  }
}

void loadModel(int index) {
  if (index >= 0 && index < fileNames.size()) {
    currentModel = loadShape(fileNames.get(index));
    if (currentModel != null) {
      println("Loaded model: " + fileNames.get(index));
    } else {
      println("Failed to load model: " + fileNames.get(index));
    }
  }
}

void keyPressed() {
  if (keyCode == RIGHT) {
    currentIndex = (currentIndex + 1) % fileNames.size();  // Move to the next model
    loadModel(currentIndex);
  } else if (keyCode == LEFT) {
    currentIndex = (currentIndex - 1 + fileNames.size()) % fileNames.size();  // Move to the previous model
    loadModel(currentIndex);
  }
}
