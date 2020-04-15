class ColorObject {

  final String hexCodeStr;
  final String name;

  // Learning note: this is syntactic sugar for constructor
  ColorObject (this.hexCodeStr, this.name);

  int getHexInt() {
    return int.parse("0xff" + hexCodeStr);
  }

  Map<String, dynamic> toJson() => {
    "hex": hexCodeStr,
    "name": name,
  };

}