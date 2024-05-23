import 'package:epub_editor/src/schema/opf/epub_guide.dart';
import 'package:epub_editor/src/schema/opf/epub_manifest.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata.dart';
import 'package:epub_editor/src/schema/opf/epub_spine.dart';
import 'package:epub_editor/src/utils/types/epub_version.dart';
import 'package:quiver/collection.dart';

class EpubPackage {
  EpubPackage({
    EpubMetadata? metadata,
    EpubSpine? spine,
    EpubManifest? manifest,
    EpubVersion? version,
    this.uniqueIdentifier,
    this.namespaces,
    this.guide,
    this.dir,
    this.lang,
  })  : this.metadata = metadata ?? EpubMetadata(),
        this.spine = spine ?? EpubSpine(),
        this.manifest = manifest ?? EpubManifest(),
        this.version = version ?? EpubVersion.epub2;

  EpubMetadata metadata;
  EpubSpine spine;
  EpubManifest manifest;
  EpubVersion version;

  String? uniqueIdentifier;
  Map<String, String>? namespaces;
  EpubGuide? guide;
  String? dir;
  String? lang;

  @override
  int get hashCode => Object.hashAll([
        uniqueIdentifier.hashCode,
        ...?namespaces?.keys.map((e) => e.hashCode),
        ...?namespaces?.values.map((e) => e.hashCode),
        version.hashCode,
        metadata.hashCode,
        manifest.hashCode,
        spine.hashCode,
        guide.hashCode,
        dir.hashCode,
        lang.hashCode,
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubPackage)) {
      return false;
    }

    return uniqueIdentifier == other.uniqueIdentifier &&
        mapsEqual(namespaces, other.namespaces) &&
        version == other.version &&
        metadata == other.metadata &&
        manifest == other.manifest &&
        spine == other.spine &&
        guide == other.guide &&
        dir == other.dir &&
        lang == other.lang;
  }
}
