extension UriX<T extends String> on T {
  Uri get toUri => Uri.parse(this);
}
