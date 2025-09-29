import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';

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
        color: CustomColors.white,
      ),
      child: CountryListPick(
        appBar: AppBar(
          backgroundColor: CustomColors.white,
          title: Text(
            'Choose a country',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: CustomColors.black,
            ),
          ),
        ),
        pickerBuilder: (context, CountryCode? countryCode) {
          return Text(
            countryCode!.dialCode!,
            style: inter14black500(context),
          );
        },
        theme: CountryTheme(
          alphabetSelectedBackgroundColor: Colors.black,
          searchHintText: 'Enter name of country here',
          isShowFlag: false,
          isShowTitle: false,
          isShowCode: true,
          isDownIcon: false,
          showEnglishName: false,
        ),
        initialSelection: widget.countryCode,
        onChanged: (CountryCode? code) {
          setState(() {
            widget.countryCode = code!.dialCode!;
          });
        },
      ),
    );
  }
}
