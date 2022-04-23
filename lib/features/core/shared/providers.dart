import 'package:dio/dio.dart';
import 'package:repo_viewer/features/github/core/data/sembast_database.dart';
import 'package:riverpod/riverpod.dart';

final sembastProvider = Provider((ref) => SembastDatabase());

final dioProvider = Provider((ref) => Dio());
