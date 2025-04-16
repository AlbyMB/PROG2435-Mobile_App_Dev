import "dart:math";

void main() {
  Random random = new Random();
  print(random.nextInt(10));

  String name  = "Alby";
  String greeting = "Hello Mr. $name , How are you ?";

  print(greeting);

  if(name == "sss" ){
    print("Lerned if");
  }
  else if(name == "Alby") {
    print("learned if else");
  }
  else{
    print("Learned else");
  }

  List<int> numbers = [1,2,3,44,234,234,6,234,243,234,242,34,235,52,5,2532,52,2,5,25,234];
  print(numbers);
  print(numbers.length);
  print(numbers[1]);
  numbers.add(5);
  print(numbers.length);
  numbers.remove(2);
  numbers.removeAt(0);
  print(numbers.length);
  for(int number in numbers){
    print(number);
  }

  
}
