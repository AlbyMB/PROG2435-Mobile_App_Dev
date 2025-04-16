void main(){
  List<String> productNames = ["Apples", "Bananas", "Cherries", "Dates"];
  List<double> productPrices = [10.5, 2.35,   25, 36.41];
  List<String> expensiveProducts =[];

  for(int i=0; i < productNames.length; i++){
    if(productPrices[i]>3.99){
      expensiveProducts.add(productNames[i]);
    }
  }

  print(expensiveProducts);
}