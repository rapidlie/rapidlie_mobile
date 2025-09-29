import 'dart:ui';

class CustomColors {
  static Color colorFromHex(String colorCode) {
    final hexCode = colorCode.replaceAll('#', '');
    Color newColor = Color(int.parse('FF$hexCode', radix: 16));
    return newColor;
  }

  static Color primary = colorFromHex('#3E62F0');
  static Color primaryLight = colorFromHex('#DBE8F8');
  static Color primaryDeep = colorFromHex('#137AF3');
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
  static Color acceptedContainerColor = colorFromHex('#EBFAF1');
  static Color acceptedTextColor = colorFromHex('#24AE5F');
  static Color rejectedContainerColor = colorFromHex('#FFF1E6');
  static Color rejectedTextColor = colorFromHex('#E57E25');
  static Color pendingContainerColor = colorFromHex('#CDF1FF');
  static Color pendingTextColor = colorFromHex('#00ACE9');
  static Color acceptButtonColor = colorFromHex('#4CAF50');
  static Color declineButtonColor = const Color.fromARGB(160, 183, 183, 183);
}
