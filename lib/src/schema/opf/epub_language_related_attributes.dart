class EpubLanguageRelatedAttributes {
  /// https://www.w3.org/TR/epub-33/#attrdef-xml-lang
  String? XmlLang;

  /// Paragraph direction/Global base direction. (v3.0)
  ///
  /// Reading systems will assume the value "auto" when EPUB creators omit the attribute or use an invalid value.
  /// https://www.w3.org/TR/epub-33/#attrdef-dir
  String? Dir;

  EpubLanguageRelatedAttributes({
    this.XmlLang,
    this.Dir,
  });
}
