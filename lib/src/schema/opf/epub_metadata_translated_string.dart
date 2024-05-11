import 'package:quiver/core.dart';

import 'epub_language_related_attributes.dart';
import 'epub_metadata_string.dart';

class EpubMetadataTranslatedString extends EpubMetadataString {
  EpubMetadataTranslatedString({
    super.id,
    super.value,
    this.languageRelatedAttributes,
  });

  EpubLanguageRelatedAttributes? languageRelatedAttributes;

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
