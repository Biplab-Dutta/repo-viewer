import 'package:collection/collection.dart';
import 'package:repo_viewer/features/github/core/data/github_repo_dto.dart';
import 'package:repo_viewer/features/github/core/data/pagination_config.dart';
import 'package:repo_viewer/features/github/core/data/sembast_database.dart';
import 'package:sembast/sembast.dart';

class StarredRepoLocalDataSource {
  StarredRepoLocalDataSource(
    SembastDatabase sembastDatabase,
  ) : _sembastDatabase = sembastDatabase;

  final SembastDatabase _sembastDatabase;
  final _store = intMapStoreFactory.store('starredRepos');
  final _itemsPerPage = PaginationConfig.itemsPerPage;

  Future<void> upsertPage(List<GithubRepoDTO> dtos, int page) async {
    final sembastPage = page - 1;
    await _store
        .records(
          dtos.mapIndexed<int>(
            (index, _) => index + _itemsPerPage * sembastPage,
          ),
        )
        .put(
          _sembastDatabase.instance,
          dtos.map((e) => e.toJson()).toList(),
        );
  }

  Future<List<GithubRepoDTO>> getPage(int page) async {
    final sembastPage = page - 1;
    final records = await _store.find(
      _sembastDatabase.instance,
      finder: Finder(
        limit: _itemsPerPage,
        offset: sembastPage * _itemsPerPage,
      ),
    );
    return records.map((e) => GithubRepoDTO.fromJson(e.value)).toList();
  }

  Future<int> getLocalPageCount() async {
    final repoCount = await _store.count(_sembastDatabase.instance);
    return (repoCount / PaginationConfig.itemsPerPage).ceil();
  }
}
