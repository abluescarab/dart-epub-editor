import 'package:quiver/core.dart';

class EpubMetadataString {
  EpubMetadataString({
    this.id,
    this.value,
  });

  String? id;
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
