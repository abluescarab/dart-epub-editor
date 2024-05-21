import 'package:epub_editor/src/schema/opf/epub_metadata_alternate_script.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_field.dart';
import 'package:quiver/collection.dart';

class EpubMetadataContributor extends EpubMetadataField {
  EpubMetadataContributor({
    super.id,
    this.name,
    this.fileAs,
    this.role,
    this.displaySeq,
    this.dir,
    this.lang,
    this.alternateScripts,
  });

  String? name;
  String? fileAs;
  String? role;
  int? displaySeq;
  String? dir;
  String? lang;

  /// meta[property="alternate-script"] (v3.0).
  List<EpubMetadataAlternateScript>? alternateScripts;

  @override
  int get hashCode => Object.hashAll([
        id.hashCode,
        name.hashCode,
        fileAs.hashCode,
        role.hashCode,
        displaySeq.hashCode,
        dir.hashCode,
        lang.hashCode,
        ...?alternateScripts?.map((e) => e.hashCode),
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubMetadataContributor)) {
      return false;
    }

    return id == other.id &&
        name == other.name &&
        fileAs == other.fileAs &&
        role == other.role &&
        displaySeq == other.displaySeq &&
        dir == other.dir &&
        lang == other.lang &&
        listsEqual(alternateScripts, other.alternateScripts);
  }
}
