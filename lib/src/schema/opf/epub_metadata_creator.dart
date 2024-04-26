import 'package:quiver/collection.dart';
import 'package:quiver/core.dart';

import '../../../epub_editor.dart';
import 'epub_metadata_creator_alternate_script.dart';

class EpubMetadataCreator {
  String? id;
  String? creator;
  String? fileAs;
  String? role;
  int? displaySeq;

  /// meta[property="alternate-script"] (v3.0).
  List<EpubMetadataCreatorAlternateScript>? alternateScripts;
  EpubLanguageRelatedAttributes? languageRelatedAttributes;

  @override
  int get hashCode => hash4(
        id.hashCode,
        creator.hashCode,
        fileAs.hashCode,
        role.hashCode,
      );

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataCreator?;
    if (otherAs == null) return false;
    return (id == otherAs.id &&
        creator == otherAs.creator &&
        fileAs == otherAs.fileAs &&
        role == otherAs.role &&
        displaySeq == otherAs.displaySeq &&
        listsEqual(alternateScripts, otherAs.alternateScripts));
  }
}
