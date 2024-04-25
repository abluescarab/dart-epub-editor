import '../../../epub_editor.dart' show EpubLanguageRelatedAttributes;

/// Represents a publisher of the EPUB book.
///
/// https://os.vers.one/EpubReader/reference/VersOne.Epub.Schema.EpubMetadataPublisher.html
class EpubMetadataPublisher {
  String? Id;
  /// The text content of this publisher.
  String Publisher;
  EpubLanguageRelatedAttributes LanguageRelatedAttributes;

  EpubMetadataPublisher({
    required this.Id,
    required this.Publisher,
    required this.LanguageRelatedAttributes,
  });

  @override
  bool operator ==(other) {
    final otherAs = (other as EpubMetadataPublisher?);

    if (otherAs == null) return false;

    return ((Id == otherAs.Id) && (Publisher == otherAs.Publisher) && (LanguageRelatedAttributes == otherAs.LanguageRelatedAttributes));
  }
}
