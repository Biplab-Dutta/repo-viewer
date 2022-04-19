import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repo_viewer/features/github/core/domain/user.dart';

part 'github_repo.freezed.dart';

@freezed
class GithubRepo with _$GithubRepo {
  const factory GithubRepo({
    required User owner,
    required String name,
    required String description,
    required int stargazersCount,
  }) = _GithubRepo;

  const GithubRepo._();

  String get fullName => '${owner.name}/$name';
}
