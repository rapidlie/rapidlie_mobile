import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/events/presentation/pages/create_event/fifth_sheet_widget.dart';
import 'package:rapidlie/features/events/presentation/pages/create_event/first_sheet_widget.dart';
import 'package:rapidlie/features/events/presentation/pages/create_event/fourth_sheet_widget.dart';
import 'package:rapidlie/features/events/presentation/pages/create_event/second_sheet_widget.dart';
import 'package:rapidlie/features/events/presentation/pages/create_event/third_sheet_widget.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  late PageController _pageViewController;
  var language;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: "Create Event",
          isSubPage: true,
        ),
      ),
      backgroundColor: CustomColors.colorFromHex("#F2F4F5"),
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          width: Get.width,
          child: PageView(
              controller: _pageViewController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                FirstSheetWidget(
                  pageViewController: _pageViewController,
                  language: language,
                ),
                SecondSheetContentWidget(
                  language: language,
                  pageViewController: _pageViewController,
                ),
                ThirdSheetContentWidget(
                  language: language,
                  pageViewController: _pageViewController,
                ),
                FourthSheetContentWidget(
                  language: language,
                  pageViewController: _pageViewController,
                ),
                FifthSheetContentWidget()
              ]),
        ),
      ),
    );
  }
}
