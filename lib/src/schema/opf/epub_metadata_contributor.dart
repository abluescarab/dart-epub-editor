import 'package:quiver/collection.dart';
import 'package:quiver/core.dart';

import '../../../epubx.dart';
import 'epub_metadata_creator_alternate_script.dart';

class EpubMetadataContributor {
  String? Id;
  String? Contributor;
  String? FileAs;
  String? Role;
  String? DisplaySeq;

  /// meta[property="alternate-script"] (v3.0).
  List<EpubMetadataCreatorAlternateScript>? AlternateScripts;
  EpubLanguageRelatedAttributes? LanguageRelatedAttributes;

  @override
  int get hashCode => hash4(
        Id.hashCode,
        Contributor.hashCode,
        FileAs.hashCode,
        Role.hashCode,
      );

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataContributor?;
    if (otherAs == null) return false;
    return (Id == otherAs.Id &&
        Contributor == otherAs.Contributor &&
        FileAs == otherAs.FileAs &&
        Role == otherAs.Role &&
        DisplaySeq == otherAs.DisplaySeq &&
        listsEqual(AlternateScripts, otherAs.AlternateScripts));
  }
}
