// Main file for same-name class isolation test
import 'multi_file_a.dart' as a;
import 'multi_file_same_name.dart' as c;

void main() {
  // Animal from file A
  final dogA = a.Dog('Buddy');
  print('From A: ${dogA.speak()}');

  // Animal from file C (same name, different class)
  final animalC = c.Animal('Tiger');
  print('From C: ${animalC.describe()}');

  // Test that they are isolated
  a.greetFromA(dogA);
  c.describeAnimal(animalC);
}
