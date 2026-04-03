// Drop-in helper for Ludo (or any Dart app) so manifest keys match `manifest.json`
// after spaces → underscores and Unicode case folding (same as String.toLowerCase).
//
// Usage: lookupPath = manifest['byNormalizedName']![normalizeAiProfileLookupKey(profile.name)];

/// Builds the lookup key for [AIProfile.name] to match this repo's `manifest.json`.
///
/// Mirrors typical Dart/Flutter behavior: trim, collapse whitespace to `_`, then
/// [String.toLowerCase] (required for Cyrillic and Latin; Arabic/Thai generally unchanged).
String normalizeAiProfileLookupKey(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '';
  final withUnderscores = trimmed.replaceAll(RegExp(r'\s+'), '_');
  return withUnderscores.toLowerCase();
}
