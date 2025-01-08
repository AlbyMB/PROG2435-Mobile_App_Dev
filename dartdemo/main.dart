import "dart:math";

void main() {
  Random random = new Random();
  print(random.nextInt(10));

  String name  = "Alby";
  String greeting = "Hello Mr. $name , How are you ?";

  print(greeting);
}