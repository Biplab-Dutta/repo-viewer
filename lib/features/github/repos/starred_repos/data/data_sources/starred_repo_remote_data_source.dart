import 'package:dio/dio.dart';
import 'package:repo_viewer/features/core/data/dio_extensions.dart';
import 'package:repo_viewer/features/core/data/json_parsers.dart';
import 'package:repo_viewer/features/core/data/network_exceptions.dart';
import 'package:repo_viewer/features/core/data/remote_response.dart';
import 'package:repo_viewer/features/github/core/data/github_headers.dart';
import 'package:repo_viewer/features/github/core/data/github_headers_cache.dart';
import 'package:repo_viewer/features/github/core/data/github_repo_dto.dart';
import 'package:repo_viewer/features/github/core/data/pagination_config.dart';

typedef GithubRepoDTOList = Future<RemoteResponse<List<GithubRepoDTO>>>;

class StarredRepoRemoteDataSource {
  StarredRepoRemoteDataSource(
    Dio dio,
    GithubHeadersCache headersCache,
  )   : _dio = dio,
        _headersCache = headersCache;

  final Dio _dio;
  final GithubHeadersCache _headersCache;

  GithubRepoDTOList getStarredReposPage(
    int page, {
    required JsonParser<List<GithubRepoDTO>> parser,
  }) async {
    final requestUri = Uri.https(
      'api.github.com',
      '/user/starred',
      <String, String>{
        'page': page.toString(),
        'per_page': PaginationConfig.itemsPerPage.toString(),
      },
    );

    final previousHeaders = await _headersCache.getHeaders(requestUri);

    try {
      final response = await _dio.getUri<String>(
        requestUri,
        options: Options(
          headers: <String, String>{
            'If-None-Match': previousHeaders?.etag ?? ''
          },
        ),
      );
      if (response.statusCode == 304) {
        return RemoteResponse.notModified(
          maxPage: previousHeaders?.link?.maxPage ?? 0,
        );
      } else if (response.statusCode == 200) {
        final headers = GithubHeaders.parse(response);
        await _headersCache.saveHeaders(requestUri, headers);
        final parsedData = await parser.parseFromJson(response.data!);
        return RemoteResponse.withNewData(
          parsedData,
          maxPage: headers.link?.maxPage ?? 1,
        );
      } else {
        throw RestApiException(response.statusCode);
      }
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        return RemoteResponse.noConnection(
          maxPage: previousHeaders?.link?.maxPage ?? 0,
        );
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}
