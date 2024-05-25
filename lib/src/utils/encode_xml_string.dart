String encodeXmlString(String original) {
  return original
    ..replaceAll('&', '&amp;')
    ..replaceAll('<', '&lt;')
    ..replaceAll('>', '&gt;')
    ..replaceAll('"', '&quot;')
    ..replaceAll('\n', '&#13;');
}
