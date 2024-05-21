import 'package:epub_editor/src/schema/opf/epub_package.dart';
import 'package:epub_editor/src/schema/opf/epub_version.dart';
import 'package:epub_editor/src/utils/namespaces.dart';
import 'package:epub_editor/src/writers/epub_guide_writer.dart';
import 'package:epub_editor/src/writers/epub_manifest_writer.dart';
import 'package:epub_editor/src/writers/epub_spine_writer.dart';
import 'package:xml/src/xml/builder.dart' show XmlBuilder;
import 'epub_metadata_writer.dart';

class EpubPackageWriter {
  static String writeContent(EpubPackage package) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');

    builder.element('package', attributes: {
      'version': package.version == EpubVersion.epub2 ? '2.0' : '3.0',
      'unique-identifier': package.uniqueIdentifier ?? 'etextno',
    }, nest: () {
      if (package.namespaces != null) {
        for (final namespace in package.namespaces!.entries) {
          try {
            builder.namespace(namespace.value, namespace.key);
          } catch (_) {
            builder.namespace(namespace.value);
          }
        }
      } else {
        builder.namespace(Namespaces.opf);
      }

      EpubMetadataWriter.writeMetadata(
        builder,
        package.metadata,
        package.version,
      );
      EpubManifestWriter.writeManifest(builder, package.manifest);
      EpubSpineWriter.writeSpine(builder, package.spine!);

      if (package.guide != null) {
        EpubGuideWriter.writeGuide(builder, package.guide);
      }
    });

    return builder.buildDocument().toXmlString(pretty: true);
  }
}
