import 'package:flutter/material.dart';
import 'package:nts/view/Theme/theme_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
   WebView({Key? key, required this.title}) : super(key: key);

   final String title;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  WebViewController? _webViewController;

  @override
  void initState() {
    _webViewController = WebViewController()
      ..loadRequest(widget.title == "personalRule"
          ? Uri.parse(
              'https://gratis-grill-b83.notion.site/80495aed10ea4b6895be2ba024a08bae?pvs=4')
          : widget.title == "service"
              ? Uri.parse(
                  "https://gratis-grill-b83.notion.site/3e8a708828284600b3d9cc29239fdb46?pvs=4")
              : Uri.parse(
                  "https://gratis-grill-b83.notion.site/be711ba5cada4a87ae8aeec521b29364?pvs=4"))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.title);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyThemeColors.primaryColor,
      ),
      body: WebViewWidget(controller: _webViewController!),
    );
  }
}
