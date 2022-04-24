import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repo_viewer/features/core/domain/fresh.dart';
import 'package:repo_viewer/features/github/core/domain/github_failure.dart';
import 'package:repo_viewer/features/github/core/domain/github_repo.dart';

part 'starred_repos_state.freezed.dart';

@freezed
class StarredReposState with _$StarredReposState {
  const factory StarredReposState.initial(
    Fresh<List<GithubRepo>> repos,
  ) = _Initial;
  const factory StarredReposState.loading(
    Fresh<List<GithubRepo>> repos,
    int itemsPerPage,
  ) = _Loading;
  const factory StarredReposState.loaded(
    Fresh<List<GithubRepo>> repos, {
    required bool isNextPageAvailable,
  }) = _Loaded;
  const factory StarredReposState.failed(
    Fresh<List<GithubRepo>> repos,
    GithubFailure failure,
  ) = _Failed;
}
