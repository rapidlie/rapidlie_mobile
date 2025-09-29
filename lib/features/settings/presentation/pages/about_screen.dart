import 'package:flutter/material.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({Key? key}) : super(key: key);

  var language;

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://rapidlie.github.io/about/'));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: SafeArea(
          child: AppBarTemplate(
            pageTitle: language.aboutApp,
            isSubPage: true,
          ),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
