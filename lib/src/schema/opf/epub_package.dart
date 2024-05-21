import 'package:epub_editor/src/schema/opf/epub_guide.dart';
import 'package:epub_editor/src/schema/opf/epub_manifest.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata.dart';
import 'package:epub_editor/src/schema/opf/epub_spine.dart';
import 'package:epub_editor/src/schema/opf/epub_version.dart';
import 'package:quiver/collection.dart';

class EpubPackage {
  EpubPackage({
    this.uniqueIdentifier,
    this.namespaces,
    this.version,
    this.metadata,
    this.manifest,
    this.spine,
    this.guide,
    this.dir,
    this.lang,
  });

  String? uniqueIdentifier;
  Map<String, String>? namespaces;
  EpubVersion? version;
  EpubMetadata? metadata;
  EpubManifest? manifest;
  EpubSpine? spine;
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
