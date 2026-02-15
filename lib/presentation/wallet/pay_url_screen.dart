import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayWithUrlScreen extends StatefulWidget {
  final String checkoutUrl; // ده الـ URL اللي جاي من الـ backend

  const PayWithUrlScreen({super.key, required this.checkoutUrl});

  @override
  State<PayWithUrlScreen> createState() => _PayWithUrlScreenState();
}

class _PayWithUrlScreenState extends State<PayWithUrlScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _handleUrlChange,
          onNavigationRequest: (request) {
            _handleUrlChange(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  void _handleUrlChange(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    final success = uri.queryParameters['success'];
    final txnCode = uri.queryParameters['txn_response_code'];

    if (success == 'true' && txnCode == 'APPROVED') {
      //Todo Success
      Navigator.of(context).pop(true);
    } else {
      //Todo Fail
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
