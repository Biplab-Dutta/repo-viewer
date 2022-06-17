import 'package:flutter/material.dart';
import 'package:repo_viewer/features/auth/data/github_authenticator.dart';
import 'package:repo_viewer/features/core/data/to_uri_extension.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthorizationPage extends StatelessWidget {
  AuthorizationPage({
    super.key,
    required this.authorizationUrl,
    required this.onAuthorizationCodeRedirectAttempt,
    CookieManager? cookieManager,
  }) : _cookieManager = cookieManager ?? CookieManager();

  final Uri authorizationUrl;
  final void Function(Uri) onAuthorizationCodeRedirectAttempt;
  final CookieManager _cookieManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: authorizationUrl.toString(),
          onWebViewCreated: (controller) async {
            await controller.clearCache();
            await _cookieManager.clearCookies();
          },
          navigationDelegate: (navReq) {
            if (navReq.url.startsWith(
              GithubAuthenticator.redirectUrl.toString(),
            )) {
              onAuthorizationCodeRedirectAttempt(navReq.url.toUri);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
