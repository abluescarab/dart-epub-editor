import 'package:quiver/collection.dart';

import 'epub_metadata_field.dart';

class EpubMetadataTranslatedString extends EpubMetadataField {
  EpubMetadataTranslatedString({
    super.id,
    this.value,
    this.dir,
    this.lang,
    this.attributes,
  });

  String? value;
  String? dir;
  String? lang;
  Map<String, String>? attributes;

  @override
  int get hashCode => Object.hash(id.hashCode, value.hashCode, dir.hashCode, lang.hashCode, attributes.hashCode);

  @override
  bool operator ==(Object other) {
    final otherAs = other as EpubMetadataTranslatedString?;

    if (otherAs == null) {
      return false;
    }

    return id == otherAs.id &&
        value == otherAs.value &&
        dir == otherAs.dir &&
        lang == otherAs.lang &&
        mapsEqual(attributes, otherAs.attributes);
  }
}
