abstract class EpubMetadataField {
  EpubMetadataField({this.id});

  String? id;

  @override
  bool operator ==(Object other) {
    if (!(other is EpubMetadataField)) {
      return false;
    }

    return id == other.id;
  }
}
