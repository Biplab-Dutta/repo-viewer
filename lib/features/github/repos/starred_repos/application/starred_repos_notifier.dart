import 'package:repo_viewer/features/github/repos/core/application/paginated_repos_notifier.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/data/repository/starred_repos_repository.dart';

class StarredReposNotifier extends PaginatedReposNotifier {
  StarredReposNotifier(StarredReposRepository repository)
      : _repository = repository;

  final StarredReposRepository _repository;

  Future<void> getNextStarredReposPage() async =>
      super.getNextPage(_repository.getStarredReposPage);
}
