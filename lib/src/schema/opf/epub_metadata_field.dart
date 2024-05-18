abstract class EpubMetadataField {
  EpubMetadataField({this.id});

  String? id;

  @override
  bool operator ==(Object other) {
    final otherAs = other as EpubMetadataField?;
    if (otherAs == null) return false;
    return id == otherAs.id;
  }
}
