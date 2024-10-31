import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';

// ignore: must_be_immutable
class CountryCodeLayout extends StatefulWidget {
  String countryCode;

  CountryCodeLayout({required this.countryCode});

  @override
  _CountryCodeLayoutState createState() => _CountryCodeLayoutState();
}

class _CountryCodeLayoutState extends State<CountryCodeLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CustomColors.gray, width: 2),
      ),
      child: CountryListPick(
        appBar: AppBar(
          backgroundColor: CustomColors.white,
          title: Text(
            'Choose a country',
            style: poppins14black500(),
          ),
        ),
        pickerBuilder: (context, CountryCode? countryCode) {
          return Text(
            countryCode!.dialCode ?? "",
            style: poppins14black500(),
          );
        },
        // to show or hide flag
        theme: CountryTheme(
          alphabetSelectedBackgroundColor: CustomColors.secondary,
          searchHintText: 'Enter name of country here',
          isShowFlag: false,
          isShowTitle: false,
          isShowCode: true,
          isDownIcon: false,
          showEnglishName: false,
        ),
        // to initial code number country
        initialSelection: widget.countryCode,
        // to get feedback data from picker
        onChanged: (CountryCode? code) {
          setState(() {
            widget.countryCode = code!.dialCode!;
          });
        },
      ),
    );
  }
}
