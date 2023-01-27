import 'dart:ui';

class ColorConstants {
  static Color colorFromHex(String colorCode) {
    final hexCode = colorCode.replaceAll('#', '');
    Color newColor = Color(int.parse('FF$hexCode', radix: 16));
    return newColor;
  }

  static Color primary = colorFromHex('#3F8FED');
  static Color secondary = colorFromHex('#092147');
  static Color white = colorFromHex('#FFFFFF');
  static Color black = colorFromHex('#000000');
  static Color gray = colorFromHex('#EAEAEA');
  static Color copyLinkColour = colorFromHex('##CDCDCD');
  static Color hintTextColor = colorFromHex('#808080');
  static Color unsafeBoxColor = colorFromHex('#F5EDE0');
  static Color addFriendsBoxColor = colorFromHex('#E3F1F4');
  static Color lightGray = colorFromHex('#E1E1E1');
  static Color closeButtonColor = colorFromHex('#848489');
  static Color charcoalBlack = colorFromHex('#0E0E0E');
  static Color gray900 = colorFromHex('#0e1339');
}
