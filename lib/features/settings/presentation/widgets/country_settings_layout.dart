import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class CountrySettingsLayout extends StatelessWidget {
  CountrySettingsLayout({Key? key}) : super(key: key);

  late final language;

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    return CountryListPick(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Select a country",
        ),
        titleTextStyle: subAppbarTitleStyle(),
        titleSpacing: 1,
        automaticallyImplyLeading: true,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      theme: CountryTheme(
        isShowFlag: false,
        isShowTitle: true,
        isShowCode: false,
        isDownIcon: false,
        showEnglishName: false,
        alphabetSelectedBackgroundColor: Colors.black,
        labelColor: Colors.black,
      ),
      pickerBuilder: (context, countryCode) {
        return Text(
          countryCode!.name.toString(),
          textAlign: TextAlign.justify,
          style: poppins13black400(),
        );
      },
      initialSelection: '+49',
      onChanged: (CountryCode? code) {},
      useUiOverlay: false,
      useSafeArea: false,
    );
  }
}
