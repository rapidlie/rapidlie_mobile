import 'package:flutter/material.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/events/presentation/pages/create_event/step_5.dart';
import 'package:rapidlie/features/events/presentation/pages/create_event/step_1.dart';
import 'package:rapidlie/features/events/presentation/pages/create_event/step_4.dart';
import 'package:rapidlie/features/events/presentation/pages/create_event/step_2.dart';
import 'package:rapidlie/features/events/presentation/pages/create_event/step_3.dart';
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
          pageTitle: language.createEvent,
          isSubPage: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
