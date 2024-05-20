import 'package:quiver/collection.dart';
import 'package:quiver/core.dart';

import 'epub_metadata_field.dart';

class EpubMetadataString extends EpubMetadataField {
  EpubMetadataString({
    super.id,
    this.value,
    this.attributes,
  });

  String? value;
  Map<String, String>? attributes;

  @override
  int get hashCode => hash3(id.hashCode, value.hashCode, attributes.hashCode);

  @override
  bool operator ==(Object other) {
    final otherAs = other as EpubMetadataString?;

    if (otherAs == null) {
      return false;
    }

    return id == otherAs.id &&
        value == otherAs.value &&
        mapsEqual(attributes, otherAs.attributes);
  }
}
