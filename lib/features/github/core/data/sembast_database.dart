import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class SembastDatabase {
  late Database _db;
  Database get db => _db;

  bool _hasBeenInitialized = false;

  Future<void> init() async {
    if (_hasBeenInitialized) return;
    _hasBeenInitialized = true;
    final dbDirectory = await getApplicationDocumentsDirectory();
    await dbDirectory.create(recursive: true);
    final dbPath = join(dbDirectory.path, 'repo-viewer');
    _db = await databaseFactoryIo.openDatabase(dbPath);
  }
}
