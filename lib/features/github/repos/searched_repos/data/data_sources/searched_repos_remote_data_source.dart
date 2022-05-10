import 'package:dio/dio.dart';
import 'package:repo_viewer/features/core/data/remote_response.dart';
import 'package:repo_viewer/features/github/core/data/github_headers_cache.dart';
import 'package:repo_viewer/features/github/core/data/github_repo_dto.dart';
import 'package:repo_viewer/features/github/core/data/pagination_config.dart';
import 'package:repo_viewer/features/github/repos/core/data/repos_remote_service.dart';

typedef GithubRepoDTOList = Future<RemoteResponse<List<GithubRepoDTO>>>;

class SearchedRepoRemoteDataSource extends ReposRemoteService {
  SearchedRepoRemoteDataSource(
    Dio dio,
    GithubHeadersCache headersCache,
  ) : super(dio, headersCache);

  GithubRepoDTOList getSearchedReposPage(
    int page, {
    required String query,
    // required JsonParser<List<GithubRepoDTO>> parser,
  }) async =>
      super.getPage(
        requestUri: Uri.https(
          'api.github.com',
          '/search/repositories',
          <String, String>{
            'q': query,
            'page': page.toString(),
            'per_page': PaginationConfig.itemsPerPage.toString(),
          },
        ),
        jsonDataSelector: (dynamic json) =>
            (json as Map<String, dynamic>)['items'] as List,
      );
}
