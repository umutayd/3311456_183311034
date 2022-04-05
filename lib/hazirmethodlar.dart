class HazirMethodlar implements HexaColorConverterColor {
  @override
  static int HexaColorConverter(String colorHex) {
    return int.parse(colorHex.replaceAll("#", "0xff"));
  }
}

class HexaColorConverterColor {
  static int? HexaColorConverter(String colorHex) {}
}
