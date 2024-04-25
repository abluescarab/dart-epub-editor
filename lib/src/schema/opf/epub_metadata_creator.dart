import 'package:quiver/collection.dart';
import 'package:quiver/core.dart';

import '../../../epub_editor.dart';
import 'epub_metadata_creator_alternate_script.dart';

class EpubMetadataCreator {
  String? Id;
  String? Creator;
  String? FileAs;
  String? Role;
  int? DisplaySeq;

  /// meta[property="alternate-script"] (v3.0).
  List<EpubMetadataCreatorAlternateScript>? AlternateScripts;
  EpubLanguageRelatedAttributes? LanguageRelatedAttributes;

  @override
  int get hashCode => hash4(
        Id.hashCode,
        Creator.hashCode,
        FileAs.hashCode,
        Role.hashCode,
      );

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataCreator?;
    if (otherAs == null) return false;
    return (Id == otherAs.Id &&
        Creator == otherAs.Creator &&
        FileAs == otherAs.FileAs &&
        Role == otherAs.Role &&
        DisplaySeq == otherAs.DisplaySeq &&
        listsEqual(AlternateScripts, otherAs.AlternateScripts));
  }
}
