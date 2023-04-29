import 'package:quiver/core.dart';

import '../../../epubx.dart';

class EpubMetadataContributor {
  String? Contributor;
  String? FileAs;
  String? Role;
  EpubLanguageRelatedAttributes? LanguageRelatedAttributes;

  @override
  int get hashCode =>
      hash3(Contributor.hashCode, FileAs.hashCode, Role.hashCode);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataContributor?;
    if (otherAs == null) return false;

    return Contributor == otherAs.Contributor &&
        FileAs == otherAs.FileAs &&
        Role == otherAs.Role;
  }
}
