import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart';
import 'package:repo_viewer/features/auth/data/credentials_storage/i_credentials_storage.dart';
import 'package:repo_viewer/features/auth/data/secret_constants.dart';
import 'package:repo_viewer/features/auth/domain/failure/auth_failure.dart';
import 'package:repo_viewer/features/core/data/dio_extensions.dart';
import 'package:repo_viewer/features/core/data/to_uri_extension.dart';
import 'package:repo_viewer/features/core/shared/encoder.dart';

class GithubOAuthHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return http.Client().send(request);
  }
}

class GithubAuthenticator {
  GithubAuthenticator(
    ICredentialsStorage credentialsStorage,
    Dio dio,
  )   : _credentialsStorage = credentialsStorage,
        _dio = dio;

  final ICredentialsStorage _credentialsStorage;
  final Dio _dio;

  static const scopes = ['read:user', 'repo'];

  static final authorizationEndpoint =
      'https://github.com/login/oauth/authorize'.toUri;

  static final tokenEndpoint =
      'https://github.com/login/oauth/access_token'.toUri;

  static final redirectUrl = 'http://localhost:3000/callback'.toUri;

  static final revocationEndpoint =
      'https://api.github.com/applications/$clientId/token'.toUri;

  Future<Credentials?> getSignedInCredentials() async {
    try {
      final storedCredentials = await _credentialsStorage.read();
      if (storedCredentials != null) {
        final canRefresh = storedCredentials.canRefresh;
        final isExpired = storedCredentials.isExpired;
        if (canRefresh && isExpired) {
          final failureOrCredentials = await refresh(storedCredentials);
          return failureOrCredentials.fold<Credentials?>((_) => null, id);
        }
      }
      return storedCredentials;
    } on PlatformException {
      return null;
    }
  }

  Future<bool> get isSignedIn =>
      getSignedInCredentials().then((credentials) => credentials != null);

  AuthorizationCodeGrant createGrant() => AuthorizationCodeGrant(
        clientId,
        authorizationEndpoint,
        tokenEndpoint,
        secret: clientSecret,
        httpClient: GithubOAuthHttpClient(),
      );

  Uri getAuthorizationUrl(AuthorizationCodeGrant grant) =>
      grant.getAuthorizationUrl(redirectUrl, scopes: scopes);

  Future<Either<AuthFailure, Unit>> handleAuthorizationResponse(
    AuthorizationCodeGrant grant,
    Map<String, String> queryParams,
  ) async {
    try {
      final httpClient = await grant.handleAuthorizationResponse(queryParams);
      await _credentialsStorage.save(httpClient.credentials);
      return right(unit);
    } on FormatException {
      return left(const AuthFailure.server());
    } on AuthorizationException catch (e) {
      return left(AuthFailure.server('${e.error}: ${e.description}'));
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }

  Future<Either<AuthFailure, Unit>> signOut() async {
    try {
      final accessToken = await _credentialsStorage
          .read()
          .then((credentials) => credentials?.accessToken);

      final base64EncodedString = fusedCodec.encode('$clientId:$clientSecret');

      try {
        await _dio.deleteUri<Object>(
          revocationEndpoint,
          data: {'access_token': accessToken},
          options: Options(
            headers: <String, String>{
              'Authorization': 'Basic $base64EncodedString',
            },
          ),
        );
      } on DioError catch (e) {
        if (e.isNoConnectionError) {
          log('Token not revoked because of internet connectivity issues.');
        } else {
          rethrow;
        }
      }
      return clearCredentialsStorage();
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }

  Future<Either<AuthFailure, Unit>> clearCredentialsStorage() async {
    try {
      await _credentialsStorage.clear();
      return right(unit);
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }

  Future<Either<AuthFailure, Credentials>> refresh(
    Credentials credentials,
  ) async {
    try {
      final refreshedCredentials = await credentials.refresh(
        identifier: clientId,
        secret: clientSecret,
        httpClient: GithubOAuthHttpClient(),
      );
      await _credentialsStorage.save(refreshedCredentials);
      return right(refreshedCredentials);
    } on FormatException {
      return left(const AuthFailure.server());
    } on AuthorizationException catch (e) {
      return left(AuthFailure.server('${e.error}: ${e.description}'));
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }
}
