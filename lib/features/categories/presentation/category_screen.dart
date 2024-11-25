import 'package:flutter/material.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class CategoryScreen extends StatelessWidget {
  static const String routeName = "category";
  var language;

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarTemplate(
            pageTitle: "Category name",
            isSubPage: true,
          ),
        ),
        body: SingleChildScrollView());
  }
}
