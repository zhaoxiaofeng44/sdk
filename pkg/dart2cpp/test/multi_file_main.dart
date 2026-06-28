// Main file: uses both A and B
import 'multi_file_a.dart';
import 'multi_file_b.dart';

void main() {
  final dog = Dog('Buddy');
  final cat = Cat('Whiskers');
  
  greetFromA(dog);
  greetFromA(cat);
  greetFromB(dog);
  greetFromB(cat);
}
