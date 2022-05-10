import 'package:repo_viewer/features/github/core/data/github_repo_dto.dart';
import 'package:repo_viewer/features/github/core/domain/github_repo.dart';

extension DTOListToDomainList on List<GithubRepoDTO> {
  List<GithubRepo> get toDomainList => map((e) => e.toDomain()).toList();
}
