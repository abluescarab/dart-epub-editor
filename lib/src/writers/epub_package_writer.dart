import 'package:epub_editor/src/schema/opf/epub_guide.dart';
import 'package:epub_editor/src/schema/opf/epub_manifest.dart';
import 'package:epub_editor/src/schema/opf/epub_package.dart';
import 'package:epub_editor/src/schema/opf/epub_spine.dart';
import 'package:epub_editor/src/utils/namespaces.dart';
import 'package:epub_editor/src/utils/types/epub_version.dart';
import 'package:xml/src/xml/builder.dart' show XmlBuilder;
import 'epub_metadata_writer.dart';

class EpubPackageWriter {
  static void writeManifest(XmlBuilder builder, EpubManifest? manifest) {
    builder.element('manifest', nest: () {
      manifest!.items.forEach((item) {
        builder.element('item', nest: () {
          builder
            ..attribute('id', item.id!)
            ..attribute('href', item.href!)
            ..attribute('media-type', item.mediaType!);

          if (item.properties != null) {
            builder.attribute('properties', item.properties!);
          }
        });
      });
    });
  }

  static void writeSpine(XmlBuilder builder, EpubSpine spine) {
    builder.element(
      'spine',
      attributes: {'toc': spine.tableOfContents!},
      nest: () => spine.items.forEach((spineItem) => builder.element(
            'itemref',
            attributes: {
              'idref': spineItem.idRef!,
              'linear': spineItem.isLinear! ? 'yes' : 'no'
            },
          )),
    );
  }

  static void writeGuide(XmlBuilder builder, EpubGuide? guide) {
    builder.element('guide', nest: () {
      guide!.items.forEach((guideItem) => builder.element(
            'reference',
            attributes: {
              'type': guideItem.type!,
              'title': guideItem.title!,
              'href': guideItem.href!,
            },
          ));
    });
  }

  static String writeContent(EpubPackage package) {
    final builder = XmlBuilder();

    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element(
      'package',
      attributes: {
        'version': package.version == EpubVersion.epub2 ? '2.0' : '3.0',
        'unique-identifier': package.uniqueIdentifier ?? 'etextno',
      },
      nest: () {
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

        writeManifest(builder, package.manifest);
        writeSpine(builder, package.spine!);

        if (package.guide != null) {
          writeGuide(builder, package.guide);
        }
      },
    );

    return builder.buildDocument().toXmlString(pretty: true);
  }
}
