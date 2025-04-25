import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/features/settings/providers/change_language_provider.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    language = AppLocalizations.of(context);
    supportedLanguages = [language.english, language.german, language.french];
    return Consumer<ChangeLanguageProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 60),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: supportedLanguages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    setState(() {
                      provider.changeLanguage(Locale("en"));
                      Navigator.pop(context);
                    });
                  } else if (index == 1) {
                    setState(() {
                      provider.changeLanguage(Locale("de"));
                      Navigator.pop(context);
                    });
                  } else {
                    setState(() {
                      provider.changeLanguage(Locale("fr"));
                      Navigator.pop(context);
                    });
                  }
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
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
