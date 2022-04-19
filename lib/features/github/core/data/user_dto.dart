import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repo_viewer/features/github/core/domain/user.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDTO with _$UserDTO {
  const factory UserDTO({
    @JsonKey(name: 'login') required String name,
    required String avatarUrl,
  }) = _UserDTO;

  const UserDTO._();

  factory UserDTO.fromJson(Map<String, dynamic> json) =>
      _$UserDTOFromJson(json);

  factory UserDTO.fromDomain(User user) => UserDTO(
        name: user.name,
        avatarUrl: user.avatarUrl,
      );

  User toDomain() => User(name: name, avatarUrl: avatarUrl);
}
