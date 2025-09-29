import 'package:flutter/material.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  TermsAndConditionsScreen({Key? key}) : super(key: key);

  var language;

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);

    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
          Uri.parse('https://rapidlie.github.io/terms-and-conditions/'));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: SafeArea(
          child: AppBarTemplate(
            pageTitle: language.terms,
            isSubPage: true,
          ),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
