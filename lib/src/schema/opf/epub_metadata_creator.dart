import 'package:quiver/core.dart';

import '../../../epubx.dart';

class EpubMetadataCreator {
  String? Creator;
  String? FileAs;
  String? Role;
  EpubLanguageRelatedAttributes? LanguageRelatedAttributes;

  @override
  int get hashCode => hash3(Creator.hashCode, FileAs.hashCode, Role.hashCode);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataCreator?;
    if (otherAs == null) return false;
    return Creator == otherAs.Creator &&
        FileAs == otherAs.FileAs &&
        Role == otherAs.Role;
  }
}
