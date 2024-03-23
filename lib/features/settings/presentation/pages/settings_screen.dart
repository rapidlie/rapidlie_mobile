import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/settings/presentation/widgets/settings_item_layout.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "settings";

  var language;

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarTemplate(
            pageTitle: language.settings,
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
                    language.general,
                    style: poppins14black500(),
                  ),
                  extraSmallSpacing(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      color: Colors.white,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SettingsItemLayout(
                          icon: Icons.language,
                          title: language.language,
                          value: "English",
                          iconColor: Colors.blue,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Container(
                            height: 1,
                            color: const Color.fromARGB(255, 240, 239, 239),
                          ),
                        ),
                        SettingsItemLayout(
                          icon: Icons.flag,
                          title: language.country,
                          value: "Germany",
                          iconColor: Colors.green,
                        ),
                      ],
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
/* 
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
                      }, */