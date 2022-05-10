import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/features/core/domain/fresh.dart';
import 'package:repo_viewer/features/github/core/data/pagination_config.dart';
import 'package:repo_viewer/features/github/core/domain/github_failure.dart';
import 'package:repo_viewer/features/github/core/domain/github_repo.dart';

part 'paginated_repos_notifier.freezed.dart';

typedef RepositoryGetter
    = Future<Either<GithubFailure, Fresh<List<GithubRepo>>>> Function(int);

@freezed
class PaginatedReposState with _$PaginatedReposState {
  const factory PaginatedReposState.initial(
    Fresh<List<GithubRepo>> repos,
  ) = _Initial;
  const factory PaginatedReposState.loading(
    Fresh<List<GithubRepo>> repos,
    int itemsPerPage,
  ) = _Loading;
  const factory PaginatedReposState.loaded(
    Fresh<List<GithubRepo>> repos, {
    required bool isNextPageAvailable,
  }) = _Loaded;
  const factory PaginatedReposState.failed(
    Fresh<List<GithubRepo>> repos,
    GithubFailure failure,
  ) = _Failed;
}

class PaginatedReposNotifier extends StateNotifier<PaginatedReposState> {
  PaginatedReposNotifier() : super(PaginatedReposState.initial(Fresh.yes([])));

  int _page = 1;

  @protected
  Future<void> getNextPage(
    RepositoryGetter getter,
  ) async {
    state = PaginatedReposState.loading(
      state.repos,
      PaginationConfig.itemsPerPage,
    );
    final failureOrRepos = await getter(_page);
    state = failureOrRepos.fold(
      (failure) => PaginatedReposState.failed(state.repos, failure),
      (repos) {
        _page++;
        return PaginatedReposState.loaded(
          repos.copyWith(
            entity: [...state.repos.entity, ...repos.entity],
          ),
          isNextPageAvailable: repos.isNextPageAvailable ?? false,
        );
      },
    );
  }
}
