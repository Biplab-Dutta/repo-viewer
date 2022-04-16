import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/app/app.dart';
import 'package:repo_viewer/bootstrap.dart';

void main() {
  bootstrap(() => ProviderScope(child: App()));
}
