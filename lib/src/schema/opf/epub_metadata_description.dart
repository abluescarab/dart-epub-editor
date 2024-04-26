import '../../../epub_editor.dart' show EpubLanguageRelatedAttributes;

/// Represents a description of the EPUB book.
///
/// https://os.vers.one/EpubReader/reference/VersOne.Epub.Schema.EpubMetadataDescription.html
class EpubMetadataDescription {
  String? id;
  /// The text content of this description.
  String description;
  EpubLanguageRelatedAttributes languageRelatedAttributes;

  EpubMetadataDescription({
    required this.id,
    required this.description,
    required this.languageRelatedAttributes,
  });

  @override
  bool operator ==(other) {
    final otherAs = (other as EpubMetadataDescription?);

    if (otherAs == null) return false;

    return ((id == otherAs.id) && (description == otherAs.description) && (languageRelatedAttributes == otherAs.languageRelatedAttributes));
  }
}
