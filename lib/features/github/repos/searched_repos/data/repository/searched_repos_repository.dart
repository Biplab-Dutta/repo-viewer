import 'package:dartz/dartz.dart';
import 'package:repo_viewer/features/core/data/network_exceptions.dart';
import 'package:repo_viewer/features/core/domain/fresh.dart';
import 'package:repo_viewer/features/github/core/domain/github_failure.dart';
import 'package:repo_viewer/features/github/core/domain/github_repo.dart';
import 'package:repo_viewer/features/github/repos/core/data/extensions.dart';
import 'package:repo_viewer/features/github/repos/searched_repos/data/data_sources/searched_repos_remote_data_source.dart';

typedef FailureOrGithubRepoList
    = Future<Either<GithubFailure, Fresh<List<GithubRepo>>>>;

class SearchedReposRepository {
  SearchedReposRepository(SearchedRepoRemoteDataSource remoteDataSource)
      : _remoteDataSource = remoteDataSource;

  final SearchedRepoRemoteDataSource _remoteDataSource;

  FailureOrGithubRepoList getSearchedReposPage(
    String query,
    int page,
  ) async {
    try {
      final remotePageItems = await _remoteDataSource.getSearchedReposPage(
        page,
        query: query,
      );
      return right(
        remotePageItems.maybeWhen(
          withNewData: (data, maxPage) => Fresh.yes(
            data.toDomainList,
            isNextPageAvailable: page < maxPage,
          ),
          orElse: () => Fresh.no(
            const [],
            isNextPageAvailable: false,
          ),
        ),
      );
    } on RestApiException catch (e) {
      return left(GithubFailure.api(e.errorCode));
    }
  }
}
