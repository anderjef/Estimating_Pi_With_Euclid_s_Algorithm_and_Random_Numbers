//Jeffrey Andersen


int digitsPerNumber = 5;
float loadingBarHeightPercentage = 0.1;
int calculationsPerFrame = 1;
float textWidthDivisor = 12.5, textHeightDivisor = 6.25;

String[] data;
IntList randomSequence = new IntList();
int index = 0;
int coprimeCount = 0;
float piApproximation;
float textSize;


void setup() {
  size(800, 400);
  data = loadStrings("digits.txt"); //a series of random digits is expected
  if (data == null) { //error message gets printed by loadStrings()
    noLoop();
    return;
  }
  for (int i = 0; i < data.length; i++) {
    for (String line = data[i]; line.length() > 0; line = line.substring(digitsPerNumber)) {
      randomSequence.append(parseInt(line.substring(0, digitsPerNumber))); //a series of random digits is expected
    }
  }
  textAlign(CENTER, CENTER);
  textSize = min(width / textWidthDivisor, height / textHeightDivisor);
  textSize(textSize);
  background(0);
}


void draw() {
  for (int i = 0; i < calculationsPerFrame; i++) {
    if (randomSequence.size() > 0) {
      coprimeCount += int(gcd(randomSequence.get(index), randomSequence.get(index + 1)) == 1);
    }
    index += 2;
    if (coprimeCount > 0) {
      piApproximation = sqrt(3 * float(index) / coprimeCount); //the chance that two random numbers are coprime is 6/pi^2
      fill(0);
      float widthOfText = textWidth(nf(piApproximation, 1, 6));
      rect(width / 2 - widthOfText / 2, height / 2 - textSize / 4, widthOfText, 20 + textSize / 2); //adding twenty to the rectangle height was determined to be best for the given font to make the rectangle appear symmetrical
      fill(255);
      text(nf(piApproximation, 1, 6), width / 2, height / 2); //future consideration: the precision of piApproximation on either side of the decimal place depends on the number of significant figures which is the number of significant figures in coprimeCount plus one
    }
    if (index >= randomSequence.size() - 1) {
      println("Job complete");
      noLoop();
      break;
    }
  }
  
  if (randomSequence.size() > 0) {
    float completionFraction = float(index) / randomSequence.size();
    loadingBar(round(width * completionFraction));
    if (coprimeCount > 0) {
      loadPixels();
      int errorY = round(map(abs(PI - piApproximation), 0, TWO_PI, height - 1, round(height * loadingBarHeightPercentage) + 1)); //on a scale of 0 to two pi; one is subtracted from height due to zero-indexing
      int valueY = round(map(piApproximation, 0, TWO_PI, height - 1, round(height * loadingBarHeightPercentage) + 1)); //on a scale of 0 to two pi; one is subtracted from height due to zero-indexing
      pixels[errorY * width + round((width - 1) * completionFraction)] = color(255, 0, 0); //future consideration: color customization of approximation error trendline
      pixels[valueY * width + round((width - 1) * completionFraction)] = color(0, 255, 0); //future consideration: color customization of value trendline
      updatePixels();
    }
  }
}


void loadingBar(int x) {
  fill(255);
  rect(0, 0, x, height * loadingBarHeightPercentage, width); //rectangle corners' radius changes with the canvas width
}


int gcd(int value1, int value2) { //Euclid's algorithm for calculating the greatest common divisor
  if (value2 > value1) { //make value1 the larger number
    int temp = value1;
    value1 = value2;
    value2 = temp;
  }
  int remainder = value1 % value2;
  if (remainder == 0) {
    return value2;
  }
  return gcd(value2, remainder);
}
