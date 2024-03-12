import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "settings";

  final List<Icon> settingdIcons = [
    Icon(Icons.language, color: Colors.blue),
    Icon(Icons.flag, color: Colors.green)
  ];
  final List<String> settingdTitle = ["Language", "Country"];
  final List<String> settingdValue = ["English", "Ghana"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarTemplate(
            pageTitle: AppLocalizations.of(context).settings,
            isSubPage: false,
          ),
        ),
        body: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Container(
            height: height,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Eugene Ofori Asiedu",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "+233 50 613 8718",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ),
                  ),
                  normalSpacing(),
                  Text(
                    'General',
                    style: poppins14black500(),
                  ),
                  extraSmallSpacing(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      color: Colors.white,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: settingdTitle.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                settingdIcons[index],
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  settingdTitle[index],
                                  style: poppins14black500(),
                                )
                              ]),
                              Row(
                                children: [
                                  Text(
                                    settingdValue[index],
                                    style: poppins13black400(),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey.shade300,
                                    size: 15,
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Container(
                            height: 1,
                            color: const Color.fromARGB(255, 240, 239, 239),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
