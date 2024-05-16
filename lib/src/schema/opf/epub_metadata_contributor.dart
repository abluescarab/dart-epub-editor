import 'package:quiver/collection.dart';
import 'package:quiver/core.dart';

import 'epub_metadata_alternate_script.dart';
import 'epub_metadata_translated_string.dart';

class EpubMetadataContributor extends EpubMetadataTranslatedString {
  EpubMetadataContributor({
    super.id,
    super.value,
    this.fileAs,
    this.role,
    this.displaySeq,
    super.dir,
    super.lang,
    this.alternateScripts,
  });

  String? fileAs;
  String? role;
  int? displaySeq;

  /// meta[property="alternate-script"] (v3.0).
  List<EpubMetadataAlternateScript>? alternateScripts;

  @override
  int get hashCode => hashObjects([
        id.hashCode,
        value.hashCode,
        fileAs.hashCode,
        role.hashCode,
        displaySeq.hashCode,
        dir.hashCode,
        lang.hashCode,
        alternateScripts.hashCode,
      ]);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataContributor?;
    if (otherAs == null) return false;
    return (id == otherAs.id &&
        value == otherAs.value &&
        fileAs == otherAs.fileAs &&
        role == otherAs.role &&
        displaySeq == otherAs.displaySeq &&
        dir == otherAs.dir &&
        lang == otherAs.lang &&
        listsEqual(alternateScripts, otherAs.alternateScripts));
  }
}
