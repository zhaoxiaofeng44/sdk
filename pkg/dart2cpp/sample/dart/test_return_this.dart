class Builder {
  String _value = '';
  
  Builder add(String text) {
    _value += text;
    return this;
  }
  
  String build() => _value;
}

void main() {
  var builder = Builder()
    .add('Hello')
    .add(' ')
    .add('World');
  print(builder.build());
}