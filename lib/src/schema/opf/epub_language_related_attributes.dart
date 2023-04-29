class EpubLanguageRelatedAttributes {
  /// https://www.w3.org/TR/epub-33/#attrdef-xml-lang
  final String? XmlLang;

  /// Paragraph direction/Global base direction. (v3.3)
  ///
  /// Reading systems will assume the value "auto" when EPUB creators omit the attribute or use an invalid value.
  /// https://www.w3.org/TR/epub-33/#attrdef-dir
  final String? Dir;

  const EpubLanguageRelatedAttributes({
    this.XmlLang,
    this.Dir,
  });
}
