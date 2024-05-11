import 'package:quiver/core.dart';

import 'epub_metadata_field.dart';

class EpubMetadataString extends EpubMetadataField {
  EpubMetadataString({
    super.id,
    this.value,
  });

  String? value;

  @override
  int get hashCode => hash2(id, value);

  @override
  bool operator ==(Object other) {
    final otherAs = other as EpubMetadataString?;

    if (otherAs == null) {
      return false;
    }

    return id == otherAs.id && value == otherAs.value;
  }
}
