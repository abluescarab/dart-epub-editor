import 'package:epub_editor/src/schema/opf/epub_metadata_field.dart';
import 'package:quiver/collection.dart';

class EpubMetadataString extends EpubMetadataField {
  EpubMetadataString({
    super.id,
    this.value,
    this.attributes,
  });

  String? value;
  Map<String, String>? attributes;

  @override
  int get hashCode => Object.hashAll([
        id.hashCode,
        value.hashCode,
        ...?attributes?.keys.map((e) => e.hashCode),
        ...?attributes?.values.map((e) => e.hashCode),
      ]);

  @override
  bool operator ==(Object other) {
    if (!(other is EpubMetadataString)) {
      return false;
    }

    return id == other.id &&
        value == other.value &&
        mapsEqual(attributes, other.attributes);
  }
}
