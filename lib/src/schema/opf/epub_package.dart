import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_guide.dart';
import 'epub_manifest.dart';
import 'epub_metadata.dart';
import 'epub_spine.dart';
import 'epub_version.dart';

class EpubPackage {
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
  int get hashCode => hashObjects([
        uniqueIdentifier.hashCode,
        namespaces.hashCode,
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
    final otherAs = other as EpubPackage?;
    if (otherAs == null) {
      return false;
    }

    return uniqueIdentifier == otherAs.uniqueIdentifier &&
        collections.mapsEqual(namespaces, otherAs.namespaces) &&
        version == otherAs.version &&
        metadata == otherAs.metadata &&
        manifest == otherAs.manifest &&
        spine == otherAs.spine &&
        guide == otherAs.guide &&
        dir == otherAs.dir &&
        lang == otherAs.lang;
  }
}
