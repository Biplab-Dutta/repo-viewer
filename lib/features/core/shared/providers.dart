import 'package:dio/dio.dart';
import 'package:repo_viewer/features/auth/shared/providers.dart';
import 'package:repo_viewer/features/github/core/data/sembast_database.dart';
import 'package:riverpod/riverpod.dart';

final sembastProvider = Provider((ref) => SembastDatabase());

final dioProvider = Provider(
  (ref) => Dio()
    ..options = BaseOptions(
      headers: <String, String>{
        'Accept': 'application/vnd.github.v3.html+json'
      },
      validateStatus: (status) =>
          status != null && status >= 200 && status < 400,
    )
    ..interceptors.add(ref.read(oAuth2InterceptorProvider)),
);
