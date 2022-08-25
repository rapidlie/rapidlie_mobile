import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rapidlie/constants/color_system.dart';

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
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: ColorSystem.gray,
          border: Border.all(color: ColorSystem.gray, width: 1.0)),
      child: CountryListPick(
        appBar: AppBar(
          backgroundColor: ColorSystem.secondary,
          title: Text(
            'Choose a country',
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        pickerBuilder: (context, CountryCode? countryCode) {
          return Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  countryCode?.flagUri ?? "",
                  package: 'country_list_pick',
                  width: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  countryCode!.dialCode ?? "",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Metropolis',
                    fontWeight: FontWeight.w500,
                    color: ColorSystem.black,
                  ),
                ),
              ],
            ),
          );
        },
        // to show or hide flag
        theme: CountryTheme(
          alphabetSelectedBackgroundColor: ColorSystem.secondary,
          searchHintText: 'Enter name of country here',
          isShowFlag: true,
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
