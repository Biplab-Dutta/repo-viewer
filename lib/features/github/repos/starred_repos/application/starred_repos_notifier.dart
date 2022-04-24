import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/features/core/domain/fresh.dart';
import 'package:repo_viewer/features/github/core/data/pagination_config.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/application/starred_repos_state.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/data/repository/starred_repos_repository.dart';

class StarredReposNotifier extends StateNotifier<StarredReposState> {
  StarredReposNotifier(StarredReposRepository repository)
      : _repository = repository,
        super(StarredReposState.initial(Fresh.yes([])));

  final StarredReposRepository _repository;

  int _page = 1;

  Future<void> getNextStarredReposPage() async {
    state = StarredReposState.loading(
      state.repos,
      PaginationConfig.itemsPerPage,
    );
    final failureOrRepos = await _repository.getStarredReposPage(_page);
    state = failureOrRepos.fold(
      (failure) => StarredReposState.failed(state.repos, failure),
      (repos) {
        _page++;
        return StarredReposState.loaded(
          repos.copyWith(
            entity: [...state.repos.entity, ...repos.entity],
          ),
          isNextPageAvailable: repos.isNextPageAvailable ?? false,
        );
      },
    );
  }
}
