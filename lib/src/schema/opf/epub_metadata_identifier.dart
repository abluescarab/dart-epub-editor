import 'package:quiver/core.dart';

import 'epub_metadata_field.dart';

class EpubMetadataIdentifier extends EpubMetadataField {
  EpubMetadataIdentifier({
    super.id,
    this.scheme,
    this.identifier,
  });

  String? scheme;
  String? identifier;

  @override
  int get hashCode => hash3(id.hashCode, scheme.hashCode, identifier.hashCode);

  @override
  bool operator ==(other) {
    final otherAs = other as EpubMetadataIdentifier?;
    if (otherAs == null) return false;
    return id == otherAs.id &&
        scheme == otherAs.scheme &&
        identifier == otherAs.identifier;
  }
}
