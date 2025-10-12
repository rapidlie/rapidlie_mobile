import 'package:country_code_picker/country_code_picker.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CountrySettingsLayout extends StatelessWidget {
  CountrySettingsLayout({Key? key}) : super(key: key);

  late final language;

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    return SizedBox(
      child: CountryCodePicker(
        onChanged: (value) async {
          UserPreferences().setCountry(value.code ?? "DE");
        },
        initialSelection: UserPreferences().getCountry() ?? "DE",
        showCountryOnly: true,
        showOnlyCountryWhenClosed: true,
        alignLeft: false,
        showFlagDialog: true,
        showFlag: false,
        showDropDownButton: false,
        dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        textStyle: inter14Black400(context),
        headerText: "Select a country",
        headerTextStyle: inter16Black600(context),
        pickerStyle: PickerStyle.bottomSheet,
        builder: (countryCode) {
          return Text(
            countryCode!.name.toString(),
            textAlign: TextAlign.center,
            style: inter13black400(context),
          );
        },
      ),
    );
  }
}
