import 'package:budget_bud/misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewTips extends StatefulWidget {
  const WebViewTips({super.key});

  @override
  State<WebViewTips> createState() => _WebViewTipsState();
}

class _WebViewTipsState extends State<WebViewTips> {
  double _progress = 0;
  late InAppWebViewController webView;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Daily Tips'),
        backgroundColor: AppColors.theWebsiteBlue,
        elevation: 0,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse("https://budgetbud.netlify.app"),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
          ),
          _progress < 1
              ? SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: AppColors.mainColorFour,
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
