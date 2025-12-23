// 测试 mixin 类型名中的特殊字符处理

// 定义两个 mixin
mixin Performer {
  void perform() {
    print('Performing...');
  }
}

mixin Singing {
  void sing() {
    print('Singing...');
  }
}

// 基类
class Musician {
  String name;

  Musician(this.name);

  void introduce() {
    print('I am $name');
  }
}

// 组合多个 mixin 的类
// Dart Kernel 会生成包含特殊字符的中间类名，如 _Musician&Performer&Singing
class Singer extends Musician with Performer, Singing {
  Singer(String name) : super(name);

  void showTalents() {
    introduce();
    perform();
    sing();
  }
}

void main() {
  var singer = Singer('Alice');
  singer.showTalents();
}
