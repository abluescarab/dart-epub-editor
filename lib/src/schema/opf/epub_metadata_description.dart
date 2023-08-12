import '../../../epubx.dart' show EpubLanguageRelatedAttributes;

/// Represents a description of the EPUB book.
///
/// https://os.vers.one/EpubReader/reference/VersOne.Epub.Schema.EpubMetadataDescription.html
class EpubMetadataDescription {
  String? Id;
  /// The text content of this description.
  String Description;
  EpubLanguageRelatedAttributes LanguageRelatedAttributes;

  EpubMetadataDescription({
    required this.Id,
    required this.Description,
    required this.LanguageRelatedAttributes,
  });

  @override
  bool operator ==(other) {
    final otherAs = (other as EpubMetadataDescription?);

    if (otherAs == null) return false;

    return ((Id == otherAs.Id) && (Description == otherAs.Description) && (LanguageRelatedAttributes == otherAs.LanguageRelatedAttributes));
  }
}
