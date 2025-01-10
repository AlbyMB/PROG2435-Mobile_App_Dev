void main(){
  double price = 63.2;

  const double TAXRATE = 0.13;

  double taxAmount = price * TAXRATE;

  print("Total including tax : ${(price + taxAmount).toStringAsFixed(2)}");
  }