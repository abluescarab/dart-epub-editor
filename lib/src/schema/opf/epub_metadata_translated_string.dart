import 'package:quiver/core.dart';

import 'epub_metadata_string.dart';

class EpubMetadataTranslatedString extends EpubMetadataString {
  EpubMetadataTranslatedString({
    super.id,
    super.value,
    this.dir,
    this.lang,
  });

  String? dir;
  String? lang;

  @override
  int get hashCode => hash4(id, value, dir, lang);

  @override
  bool operator ==(Object other) {
    final otherAs = other as EpubMetadataTranslatedString?;

    if (otherAs == null) {
      return false;
    }

    return id == otherAs.id &&
        value == otherAs.value &&
        dir == otherAs.dir &&
        lang == otherAs.lang;
  }
}
