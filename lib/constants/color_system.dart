import 'dart:ui';

class ColorSystem {
  static Color colorFromHex(String colorCode) {
    final hexCode = colorCode.replaceAll('#', '');
    Color newColor = Color(int.parse('FF$hexCode', radix: 16));
    return newColor;
  }

  static Color primary = colorFromHex('#1A488E');
  static Color secondary = colorFromHex('#092147');
  static Color white = colorFromHex('#FFFFFF');
  static Color black = colorFromHex('#000000');
  static Color gray = colorFromHex('#EAEAEA');
  static Color copyLinkColour = colorFromHex('##CDCDCD');
  static Color hintTextColor = colorFromHex('#808080');
  static Color unsafeBoxColor = colorFromHex('#F5EDE0');
  static Color addFriendsBoxColor = colorFromHex('#E3F1F4');
}
