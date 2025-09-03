import 'package:flutter/material.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://rapidlie.github.io/privacy-policy/'));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: SafeArea(
          child: AppBarTemplate(
            pageTitle: "Privacy Policy",
            isSubPage: true,
          ),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
