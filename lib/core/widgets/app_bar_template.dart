import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';

class AppBarTemplate extends StatelessWidget {
  final String pageTitle;
  final bool isSubPage;
  final Widget? trailingWidget;

  AppBarTemplate(
      {Key? key,
      required this.pageTitle,
      required this.isSubPage,
      this.trailingWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  isSubPage
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.arrow_back),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(pageTitle,
                          style: mainAppbarTitleStyle(context))),
                ],
              ),
              trailingWidget == null ? SizedBox() : trailingWidget!
            ],
          ),
        ),
      ),
    );
  }
}
