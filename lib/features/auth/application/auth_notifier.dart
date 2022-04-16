import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/features/auth/application/auth_state.dart';
import 'package:repo_viewer/features/auth/data/github_authenticator.dart';

typedef AuthUriCallback = Future<Uri> Function(Uri authorizationUrl);

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(GithubAuthenticator githubAuthenticator)
      : _githubAuthenticator = githubAuthenticator,
        super(const AuthState.initial());

  final GithubAuthenticator _githubAuthenticator;

  Future<void> checkAndUpdateAuthStatus() async {
    state = (await _githubAuthenticator.isSignedIn)
        ? const AuthState.authenticated()
        : const AuthState.unauthenticated();
  }

  Future<void> signIn(AuthUriCallback authorizationCallback) async {
    final grant = _githubAuthenticator.createGrant();
    final redirectUrl = await authorizationCallback(
      _githubAuthenticator.getAuthorizationUrl(grant),
    );
    final result = await _githubAuthenticator.handleAuthorizationResponse(
      grant,
      redirectUrl.queryParameters,
    );
    result.fold(
      AuthState.failure,
      (r) => const AuthState.authenticated(),
    );
    grant.close();
  }

  Future<void> signOut() async {
    final result = await _githubAuthenticator.signOut();
    result.fold(
      AuthState.failure,
      (_) => const AuthState.unauthenticated(),
    );
  }
}
