import 'package:flutter/material.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
          Uri.parse('https://rapidlie.github.io/terms-and-conditions/'));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: SafeArea(
          child: AppBarTemplate(
            pageTitle: "Terms and Conditions",
            isSubPage: true,
          ),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
