void main(){
  String mainString = " I love dart! ";

  print("Original String : ${mainString}");
  print("Uppercase String : ${mainString.toUpperCase()}");
  print("String with white space removed : ${mainString.trim()}");
  print("Does the string contain the word DART? : ${mainString.contains("dart")}");

}