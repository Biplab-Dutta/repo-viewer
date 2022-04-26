import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/features/core/shared/providers.dart';
import 'package:repo_viewer/features/github/core/data/github_headers_cache.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/application/starred_repos_notifier.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/application/starred_repos_state.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/data/data_sources/starred_repo_local_data_source.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/data/data_sources/starred_repo_remote_data_source.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/data/repository/starred_repos_repository.dart';

final githubHeadersCacheProvider = Provider(
  (ref) => GithubHeadersCache(
    ref.watch(sembastProvider),
  ),
);

final starredRepoLocalDataSourceProvider = Provider(
  (ref) => StarredRepoLocalDataSource(
    ref.watch(sembastProvider),
  ),
);

final starredRepoRemoteDataSourceProvider = Provider(
  (ref) => StarredRepoRemoteDataSource(
    ref.watch(dioProvider),
    ref.watch(githubHeadersCacheProvider),
  ),
);

final starredReposRepositoryProvider = Provider(
  (ref) => StarredReposRepository(
    ref.watch(starredRepoRemoteDataSourceProvider),
    ref.watch(starredRepoLocalDataSourceProvider),
  ),
);

final starredReposNotifierProvider =
    StateNotifierProvider<StarredReposNotifier, StarredReposState>(
  (ref) => StarredReposNotifier(
    ref.watch(starredReposRepositoryProvider),
  ),
);
