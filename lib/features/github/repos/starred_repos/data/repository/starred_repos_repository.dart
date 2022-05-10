import 'package:dartz/dartz.dart';
import 'package:repo_viewer/features/core/data/network_exceptions.dart';
import 'package:repo_viewer/features/core/domain/fresh.dart';
import 'package:repo_viewer/features/github/core/domain/github_failure.dart';
import 'package:repo_viewer/features/github/core/domain/github_repo.dart';
import 'package:repo_viewer/features/github/repos/core/data/extensions.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/data/data_sources/starred_repo_local_data_source.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/data/data_sources/starred_repo_remote_data_source.dart';

typedef FailureOrGithubRepoList
    = Future<Either<GithubFailure, Fresh<List<GithubRepo>>>>;

class StarredReposRepository {
  StarredReposRepository(
    StarredRepoRemoteDataSource remoteDataSource,
    StarredRepoLocalDataSource localDataSource,
  )   : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final StarredRepoRemoteDataSource _remoteDataSource;
  final StarredRepoLocalDataSource _localDataSource;

  FailureOrGithubRepoList getStarredReposPage(int page) async {
    try {
      final remotePageItems = await _remoteDataSource.getStarredReposPage(
        page,
        // parser: const GithubRepoDTOParser(),
      );
      return right(
        await remotePageItems.when(
          noConnection: () async => Fresh.no(
            await _localDataSource.getPage(page).then(
                  (dtoList) => dtoList.toDomainList,
                ),
            isNextPageAvailable:
                page < await _localDataSource.getLocalPageCount(),
          ),
          notModified: (maxPage) async => Fresh.yes(
            await _localDataSource.getPage(page).then(
                  (dtoList) => dtoList.toDomainList,
                ),
            isNextPageAvailable: page < maxPage,
          ),
          withNewData: (data, maxPage) async {
            await _localDataSource.upsertPage(data, page);
            return Fresh.yes(
              data.toDomainList,
              isNextPageAvailable: page < maxPage,
            );
          },
        ),
      );
    } on RestApiException catch (e) {
      return left(GithubFailure.api(e.errorCode));
    }
  }
}
