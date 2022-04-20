import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'github_headers.freezed.dart';
part 'github_headers.g.dart';

@freezed
class GithubHeaders with _$GithubHeaders {
  const factory GithubHeaders({
    String? etag,
    PaginationLink? link,
  }) = _GithubHeaders;

  factory GithubHeaders.parse(Response response) {
    final link = response.headers.map['Link']?[0];
    return GithubHeaders(
      etag: response.headers.map['ETag']?[0],
      link: link == null
          ? null
          : PaginationLink.parse(
              link.split(','),
              requestUrl: response.requestOptions.uri.toString(),
            ),
    );
  }

  factory GithubHeaders.fromJson(Map<String, dynamic> json) =>
      _$GithubHeadersFromJson(json);
}

@freezed
class PaginationLink with _$PaginationLink {
  const factory PaginationLink({
    required int maxPage,
  }) = _PaginationLink;

// The header in Dio is represented by List<String>
  factory PaginationLink.parse(
    List<String> values, {
    required String requestUrl,
  }) =>
      PaginationLink(
        maxPage: _extractPageNumber(
          values.firstWhere(
            (e) => e.contains('rel="last"'),
            orElse: () => requestUrl,
          ),
        ),
      );

  factory PaginationLink.fromJson(Map<String, dynamic> json) =>
      _$PaginationLinkFromJson(json);

  static int _extractPageNumber(String value) {
    const regExp =
        r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)';
    final stringUri = RegExp(regExp).stringMatch(value);
    return int.parse(Uri.parse(stringUri!).queryParameters['page']!);
  }
}
