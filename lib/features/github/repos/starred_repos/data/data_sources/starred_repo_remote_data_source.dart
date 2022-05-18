import 'package:repo_viewer/features/core/data/remote_response.dart';
import 'package:repo_viewer/features/github/core/data/github_repo_dto.dart';
import 'package:repo_viewer/features/github/core/data/pagination_config.dart';
import 'package:repo_viewer/features/github/repos/core/data/repos_remote_service.dart';

typedef GithubRepoDTOList = Future<RemoteResponse<List<GithubRepoDTO>>>;

class StarredRepoRemoteDataSource extends ReposRemoteService {
  StarredRepoRemoteDataSource(
    super.dio,
    super.headersCache,
  );

  GithubRepoDTOList getStarredReposPage(
    int page,
    //    {
    //   required JsonParser<List<GithubRepoDTO>> parser,
    // }
  ) async =>
      super.getPage(
        requestUri: Uri.https(
          'api.github.com',
          '/user/starred',
          <String, String>{
            'page': page.toString(),
            'per_page': PaginationConfig.itemsPerPage.toString(),
          },
        ),
        jsonDataSelector: (dynamic json) => json as List,
      );
}
