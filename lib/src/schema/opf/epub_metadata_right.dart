import '../../../epub_editor.dart' show EpubLanguageRelatedAttributes;

/// Represents the rights held in and over the EPUB book.
///
/// https://os.vers.one/EpubReader/reference/VersOne.Epub.Schema.EpubMetadataRights.html
class EpubMetadataRight {
  String? Id;
  /// The text content of the right.
  String Right;
  EpubLanguageRelatedAttributes LanguageRelatedAttributes;

  EpubMetadataRight({
    required this.Id,
    required this.Right,
    required this.LanguageRelatedAttributes,
  });

  @override
  bool operator ==(other) {
    final otherAs = (other as EpubMetadataRight?);

    if (otherAs == null) return false;

    return ((Id == otherAs.Id) && (Right == otherAs.Right) && (LanguageRelatedAttributes == otherAs.LanguageRelatedAttributes));
  }
}
