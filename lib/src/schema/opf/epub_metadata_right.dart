import '../../../epub_editor.dart' show EpubLanguageRelatedAttributes;

/// Represents the rights held in and over the EPUB book.
///
/// https://os.vers.one/EpubReader/reference/VersOne.Epub.Schema.EpubMetadataRights.html
class EpubMetadataRight {
  String? id;
  /// The text content of the right.
  String right;
  EpubLanguageRelatedAttributes languageRelatedAttributes;

  EpubMetadataRight({
    required this.id,
    required this.right,
    required this.languageRelatedAttributes,
  });

  @override
  bool operator ==(other) {
    final otherAs = (other as EpubMetadataRight?);

    if (otherAs == null) return false;

    return ((id == otherAs.id) && (right == otherAs.right) && (languageRelatedAttributes == otherAs.languageRelatedAttributes));
  }
}
