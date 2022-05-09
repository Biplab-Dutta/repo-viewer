import 'package:dio/dio.dart';
import 'package:repo_viewer/features/core/data/dio_extensions.dart';
import 'package:repo_viewer/features/core/data/network_exceptions.dart';
import 'package:repo_viewer/features/core/data/remote_response.dart';
import 'package:repo_viewer/features/github/core/data/github_headers.dart';
import 'package:repo_viewer/features/github/core/data/github_headers_cache.dart';
import 'package:repo_viewer/features/github/core/data/github_repo_dto.dart';

typedef GithubRepoDTOList = Future<RemoteResponse<List<GithubRepoDTO>>>;

abstract class ReposRemoteService {
  ReposRemoteService(
    Dio dio,
    GithubHeadersCache headersCache,
  )   : _dio = dio,
        _headersCache = headersCache;

  final Dio _dio;
  final GithubHeadersCache _headersCache;

  GithubRepoDTOList getPage({
    required Uri requestUri,
    required List<dynamic> Function(dynamic json) jsonDataSelector,
  }) async {
    final previousHeaders = await _headersCache.getHeaders(requestUri);

    try {
      final response = await _dio.getUri<Object>(
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
        // final parsedData = await compute(
        //   parser.parseFromJson,
        //   response.data!,
        // );
        final parsedData = jsonDataSelector(response.data)
            .map(
              (dynamic e) => GithubRepoDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList();
        return RemoteResponse.withNewData(
          parsedData,
          maxPage: headers.link?.maxPage ?? 1,
        );
      } else {
        throw RestApiException(response.statusCode);
      }
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        return const RemoteResponse.noConnection();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}
