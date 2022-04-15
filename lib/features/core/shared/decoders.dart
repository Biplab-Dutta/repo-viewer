import 'dart:convert';

import 'package:repo_viewer/features/core/data/json_parsers.dart';

mixin ObjectDecoder<T> on JsonParser<T> {
  Map<String, dynamic> decodeJsonObject(String json) =>
      jsonDecode(json) as Map<String, dynamic>;
}

mixin ListDecoder<T> on JsonParser<T> {
  List<Map<String, dynamic>> decodeJsonList(String json) =>
      (jsonDecode(json) as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
}
