import 'package:quiver/collection.dart';
import 'package:quiver/core.dart';

import '../../../epub_editor.dart';
import 'epub_metadata_creator_alternate_script.dart';

class EpubMetadataContributor {
  String? id;
  String? contributor;
  String? fileAs;
  String? role;
  int? displaySeq;

  /// meta[property="alternate-script"] (v3.0).
  List<EpubMetadataCreatorAlternateScript>? alternateScripts;
  EpubLanguageRelatedAttributes? languageRelatedAttributes;

  @override
  int get hashCode => hash4(
        id.hashCode,
        contributor.hashCode,
        fileAs.hashCode,
        role.hashCode,
      );

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataContributor?;
    if (otherAs == null) return false;
    return (id == otherAs.id &&
        contributor == otherAs.contributor &&
        fileAs == otherAs.fileAs &&
        role == otherAs.role &&
        displaySeq == otherAs.displaySeq &&
        listsEqual(alternateScripts, otherAs.alternateScripts));
  }
}
