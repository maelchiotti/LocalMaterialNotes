/// Encodes the query [parameters] to be used in an URI.
String? encodeQueryParameters(Map<String, String> parameters) {
  return parameters.entries.map((MapEntry<String, String> e) {
    return '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}';
  }).join('&');
}
