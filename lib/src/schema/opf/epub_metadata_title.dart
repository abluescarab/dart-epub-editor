import '../../../epub_editor.dart' show EpubLanguageRelatedAttributes;

/// Represents an instance of a name for the EPUB publication.
///
/// https://os.vers.one/EpubReader/reference/VersOne.Epub.Schema.EpubMetadataTitle.html
class EpubMetadataTitle {
  String? id;
  String title; // The text content of this title.
  EpubLanguageRelatedAttributes languageRelatedAttributes;

  EpubMetadataTitle({
    required this.id,
    required this.title,
    required this.languageRelatedAttributes,
  });

  @override
  bool operator ==(other) {
    final otherAs = (other as EpubMetadataTitle?);

    if (otherAs == null) return false;

    return ((id == otherAs.id) &&
        (title == otherAs.title) &&
        (languageRelatedAttributes == otherAs.languageRelatedAttributes));
  }
}
