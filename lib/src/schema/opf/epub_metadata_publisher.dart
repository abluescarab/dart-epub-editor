import '../../../epub_editor.dart' show EpubLanguageRelatedAttributes;

/// Represents a publisher of the EPUB book.
///
/// https://os.vers.one/EpubReader/reference/VersOne.Epub.Schema.EpubMetadataPublisher.html
class EpubMetadataPublisher {
  String? id;

  /// The text content of this publisher.
  String publisher;
  EpubLanguageRelatedAttributes languageRelatedAttributes;

  EpubMetadataPublisher({
    required this.id,
    required this.publisher,
    required this.languageRelatedAttributes,
  });

  @override
  bool operator ==(other) {
    final otherAs = (other as EpubMetadataPublisher?);

    if (otherAs == null) return false;

    return ((id == otherAs.id) &&
        (publisher == otherAs.publisher) &&
        (languageRelatedAttributes == otherAs.languageRelatedAttributes));
  }
}
