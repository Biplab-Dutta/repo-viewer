import 'package:dio/dio.dart';
import 'package:repo_viewer/features/auth/application/auth_notifier.dart';
import 'package:repo_viewer/features/auth/data/github_authenticator.dart';

class OAuth2Interceptor extends Interceptor {
  OAuth2Interceptor(
    GithubAuthenticator authenticator,
    AuthNotifier authNotifier,
    Dio dio,
  )   : _authenticator = authenticator,
        _authNotifier = authNotifier,
        _dio = dio;

  final GithubAuthenticator _authenticator;
  final AuthNotifier _authNotifier;
  final Dio _dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final credentials = await _authenticator.getSignedInCredentials();
    final modifiedOptions = options
      ..headers.addAll(
        credentials == null
            ? <String, String>{}
            : <String, String>{
                'Authorization': 'bearer ${credentials.accessToken}',
              },
      );
    handler.next(modifiedOptions);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    final errorResponse = err.response;
    if (errorResponse != null && errorResponse.statusCode == 401) {
      final credentials = await _authenticator.getSignedInCredentials();

      credentials != null && credentials.canRefresh
          ? await _authenticator.refresh(credentials)
          : await _authenticator.clearCredentialsStorage();

      await _authNotifier.checkAndUpdateAuthStatus();
      final refreshedCredentials =
          await _authenticator.getSignedInCredentials();
      if (refreshedCredentials != null) {
        handler.resolve(
          await _dio.fetch<Object>(
            errorResponse.requestOptions
              ..headers['Authorization'] =
                  'bearer ${refreshedCredentials.accessToken}',
          ),
        );
      }
    } else {
      handler.next(err);
    }
  }
}
