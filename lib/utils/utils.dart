/// Encodes the query [parameters] to be used in an URI.
String? encodeQueryParameters(Map<String, String> parameters) => parameters.entries
    .map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
    .join('&');
