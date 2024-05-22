import 'package:epub_editor/src/schema/opf/epub_metadata_field.dart';
import 'package:quiver/collection.dart';

class EpubMetadataTranslatedString extends EpubMetadataField {
  EpubMetadataTranslatedString({
    Map<String, String>? attributes,
    super.id,
    this.value,
    this.dir,
    this.lang,
  }) : this.attributes = attributes ?? {};

  Map<String, String> attributes;

  String? value;
  String? dir;
  String? lang;

  @override
  int get hashCode => Object.hashAll([
        id.hashCode,
        value.hashCode,
        dir.hashCode,
        lang.hashCode,
        ...attributes.keys.map((e) => e.hashCode),
        ...attributes.values.map((e) => e.hashCode),
      ]);

  @override
  bool operator ==(Object other) {
    if (!(other is EpubMetadataTranslatedString)) {
      return false;
    }

    return id == other.id &&
        value == other.value &&
        dir == other.dir &&
        lang == other.lang &&
        mapsEqual(attributes, other.attributes);
  }
}
