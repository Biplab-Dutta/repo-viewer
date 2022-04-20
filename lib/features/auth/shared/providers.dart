import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:repo_viewer/features/auth/application/auth_notifier.dart';
import 'package:repo_viewer/features/auth/application/auth_state.dart';
import 'package:repo_viewer/features/auth/data/credentials_storage/i_credentials_storage.dart';
import 'package:repo_viewer/features/auth/data/credentials_storage/secure_credentials_storage.dart';
import 'package:repo_viewer/features/auth/data/github_authenticator.dart';
import 'package:riverpod/riverpod.dart';

final flutterSecureStorageProvider =
    Provider((ref) => const FlutterSecureStorage());

final dioProvider = Provider((ref) => Dio());

final credentialsStorageProvider = Provider<ICredentialsStorage>(
  (ref) => SecureCredentialsStorage(
    ref.watch(flutterSecureStorageProvider),
  ),
);

final githubAuthenticatorProvider = Provider(
  (ref) => GithubAuthenticator(
    ref.watch(credentialsStorageProvider),
    ref.watch(dioProvider),
  ),
);

final authNotifierProvider =
    StateNotifierProvider.autoDispose<AuthNotifier, AuthState>(
  (ref) {
    return AuthNotifier(
      ref.watch(githubAuthenticatorProvider),
    );
  },
);
