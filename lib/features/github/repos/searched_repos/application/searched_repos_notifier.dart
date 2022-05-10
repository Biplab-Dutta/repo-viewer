import 'package:repo_viewer/features/github/repos/core/application/paginated_repos_notifier.dart';
import 'package:repo_viewer/features/github/repos/searched_repos/data/repository/searched_repos_repository.dart';

class SearchedReposNotifier extends PaginatedReposNotifier {
  SearchedReposNotifier(SearchedReposRepository repository)
      : _repository = repository;

  final SearchedReposRepository _repository;

  Future<void> getNextSearchedReposPage(String query) async =>
      super.getNextPage(
        (page) => _repository.getSearchedReposPage(query, page),
      );
}
