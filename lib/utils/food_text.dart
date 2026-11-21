String normalizeFood(String text) {
  const accents = {
    'á': 'a',
    'é': 'e',
    'í': 'i',
    'ó': 'o',
    'ú': 'u',
    'ü': 'u',
    'ñ': 'n',
  };
  var value = text.toLowerCase();
  accents.forEach(
    (key, replacement) => value = value.replaceAll(key, replacement),
  );
  return value
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ');
}

bool foodContains(String text, String term) {
  final haystack = normalizeFood(text);
  final needle = normalizeFood(term);
  if (needle.isEmpty) return false;
  return RegExp('(?:^| )${RegExp.escape(needle)}(?:s|es)?(?: |\$)')
      .hasMatch(haystack);
}
