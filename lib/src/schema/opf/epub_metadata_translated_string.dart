import 'package:quiver/core.dart';

import 'epub_language_related_attributes.dart';
import 'epub_metadata_field.dart';

class EpubMetadataTranslatedString extends EpubMetadataField {
  EpubMetadataTranslatedString({
    super.id,
    this.value,
    this.languageRelatedAttributes,
  });

  String? value;
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
