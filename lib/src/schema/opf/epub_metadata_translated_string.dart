import 'package:epub_editor/epub_editor.dart';
import 'package:quiver/core.dart';

class EpubMetadataTranslatedString extends EpubMetadataString {
  EpubMetadataTranslatedString({
    required super.id,
    required super.value,
    required this.languageRelatedAttributes,
  });

  EpubLanguageRelatedAttributes languageRelatedAttributes;

  @override
  int get hashCode => hash3(id, value, languageRelatedAttributes);

  @override
  bool operator ==(Object other) {
    final otherAs = other as EpubMetadataTranslatedString?;

    if (otherAs == null) {
      return false;
    }

    return id == otherAs.id &&
        value == otherAs.value &&
        languageRelatedAttributes == otherAs.languageRelatedAttributes;
  }
}
