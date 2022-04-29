import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repo_viewer/features/core/data/decoders.dart';
import 'package:repo_viewer/features/core/data/json_parsers.dart';
import 'package:repo_viewer/features/github/core/data/user_dto.dart';
import 'package:repo_viewer/features/github/core/domain/github_repo.dart';

part 'github_repo_dto.freezed.dart';
part 'github_repo_dto.g.dart';

@freezed
class GithubRepoDTO with _$GithubRepoDTO {
  const factory GithubRepoDTO({
    required UserDTO owner,
    required String name,
    @JsonKey(defaultValue: '') required String description,
    required int stargazersCount,
  }) = _GithubRepoDTO;

  const GithubRepoDTO._();

  factory GithubRepoDTO.fromJson(Map<String, dynamic> json) =>
      _$GithubRepoDTOFromJson(json);

  factory GithubRepoDTO.fromDomain(GithubRepo githubRepo) => GithubRepoDTO(
        owner: UserDTO.fromDomain(githubRepo.owner),
        name: githubRepo.name,
        description: githubRepo.description,
        stargazersCount: githubRepo.stargazersCount,
      );

  GithubRepo toDomain() => GithubRepo(
        owner: owner.toDomain(),
        name: name,
        description: description,
        stargazersCount: stargazersCount,
      );
}

class GithubRepoDTOParser extends JsonParser<List<GithubRepoDTO>>
    with ListDecoder<List<GithubRepoDTO>> {
  const GithubRepoDTOParser();

  @override
  Future<List<GithubRepoDTO>> parseFromJson(String json) async {
    return decodeJsonList(json)
        .map((dynamic e) => GithubRepoDTO.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
