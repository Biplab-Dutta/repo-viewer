import 'package:repo_viewer/features/github/core/data/github_headers.dart';
import 'package:repo_viewer/features/github/core/data/sembast_database.dart';
import 'package:sembast/sembast.dart';

abstract class IGithubHeadersCache {
  Future<void> saveHeaders(Uri uri, GithubHeaders githubHeaders);

  Future<GithubHeaders?> getHeaders(Uri uri);

  Future<void> deleteHeaders(Uri uri);
}

class GithubHeadersCache implements IGithubHeadersCache {
  GithubHeadersCache(
    SembastDatabase sembastDatabase,
  ) : _sembastDatabase = sembastDatabase;

  final SembastDatabase _sembastDatabase;
  final _store = stringMapStoreFactory.store('headers');

  @override
  Future<void> saveHeaders(Uri uri, GithubHeaders githubHeaders) async {
    await _store
        .record(uri.toString())
        .put(_sembastDatabase.db, githubHeaders.toJson());
  }

  @override
  Future<GithubHeaders?> getHeaders(Uri uri) async {
    final json = await _store.record(uri.toString()).get(_sembastDatabase.db);
    return json == null ? null : GithubHeaders.fromJson(json);
  }

  @override
  Future<void> deleteHeaders(Uri uri) async {
    await _store.record(uri.toString()).delete(_sembastDatabase.db);
  }
}
