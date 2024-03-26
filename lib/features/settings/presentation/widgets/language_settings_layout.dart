import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class LanguageSettingsLayout extends StatefulWidget {
  LanguageSettingsLayout({
    Key? key,
  }) : super(key: key);

  @override
  State<LanguageSettingsLayout> createState() => _LanguageSettingsLayoutState();
}

class _LanguageSettingsLayoutState extends State<LanguageSettingsLayout> {
  late List supportedLanguages;
  late var language;
  int selectedLanguage = 0;

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    supportedLanguages = [language.english, language.german, language.french];
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 60),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: supportedLanguages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedLanguage = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      supportedLanguages[index],
                      style: poppins14black500(),
                    ),
                    selectedLanguage == index
                        ? Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : SizedBox()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
