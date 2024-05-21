import 'package:epub_editor/src/schema/opf/epub_metadata_field.dart';
import 'package:quiver/core.dart';

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
    if (!(other is EpubMetadataIdentifier)) {
      return false;
    }

    return id == other.id &&
        scheme == other.scheme &&
        identifier == other.identifier;
  }
}
