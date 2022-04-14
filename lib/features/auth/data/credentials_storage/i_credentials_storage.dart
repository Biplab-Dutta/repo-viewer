import 'package:oauth2/oauth2.dart';

abstract class ICredentialsStorage {
  Future<Credentials?> read();
  Future<void> save(Credentials credentials);
  Future<void> clear();
}
