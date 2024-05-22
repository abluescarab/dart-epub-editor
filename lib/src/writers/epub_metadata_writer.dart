import 'package:epub_editor/src/schema/opf/epub_metadata.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_contributor.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_field.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_string.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_translated_string.dart';
import 'package:epub_editor/src/schema/opf/epub_version.dart';
import 'package:epub_editor/src/utils/namespaces.dart';
import 'package:xml/src/xml/builder.dart' show XmlBuilder;

class EpubMetadataWriter {
  static void _writeId(XmlBuilder builder, EpubMetadataField item) {
    if (item.id != null) {
      builder.attribute('id', item.id!);
    }
  }

  static void _writeContributor(
    XmlBuilder builder,
    EpubMetadataContributor item,
    EpubVersion? version,
  ) {
    _writeId(builder, item);

    if (version == EpubVersion.epub2) {
      if (item.role != null) {
        builder.attribute('role', item.role!, namespace: Namespaces.opf);
      }

      if (item.fileAs != null) {
        builder.attribute('file-as', item.fileAs!, namespace: Namespaces.opf);
      }
    }

    if (item.dir != null) {
      builder.attribute('dir', item.dir!);
    }

    if (item.lang != null) {
      builder.attribute('lang', item.lang!, namespace: 'xml');
    }

    builder.text(item.name!);
  }

  static void _writeString(XmlBuilder builder, EpubMetadataString item) {
    _writeId(builder, item);

    if (item.attributes != null) {
      item.attributes!.forEach((key, value) => builder.attribute(key, value));
    }

    builder.text(item.value!);
  }

  static void _writeTranslatedString(
    XmlBuilder builder,
    EpubMetadataTranslatedString item,
  ) {
    _writeId(builder, item);

    if (item.dir != null) {
      builder.attribute('dir', item.dir!);
    }

    if (item.lang != null) {
      builder.attribute('lang', item.lang!, namespace: 'xml');
    }

    if (item.attributes != null) {
      item.attributes!.forEach((key, value) => builder.attribute(key, value));
    }

    builder.text(item.value!);
  }

  static void writeMetadata(
    XmlBuilder builder,
    EpubMetadata? meta,
    EpubVersion? version,
  ) {
    builder.element(
      'metadata',
      namespaces: {Namespaces.opf: 'opf', Namespaces.dc: 'dc'},
      nest: () {
        meta!
          ..contributors.forEach((item) => builder.element(
                'contributor',
                namespace: Namespaces.dc,
                nest: () => _writeContributor(builder, item, version),
              ))
          ..coverages.forEach((item) => builder.element(
                'coverage',
                namespace: Namespaces.dc,
                nest: () => _writeTranslatedString(builder, item),
              ))
          ..coverages.forEach((item) => builder.element(
                'coverage',
                namespace: Namespaces.dc,
                nest: () => _writeTranslatedString(builder, item),
              ))
          ..creators.forEach((item) => builder.element(
                'creator',
                namespace: Namespaces.dc,
                nest: () => _writeContributor(builder, item, version),
              ))
          ..dates.forEach((item) => builder.element(
                'date',
                namespace: Namespaces.dc,
                nest: () {
                  _writeId(builder, item);

                  if (version == EpubVersion.epub2 && item.event != null) {
                    builder.attribute(
                      'event',
                      item.event!,
                      namespace: Namespaces.opf,
                    );
                  }

                  builder.text(item.date!);
                },
              ))
          ..descriptions.forEach((item) => builder.element(
                'description',
                namespace: Namespaces.dc,
                nest: () => _writeTranslatedString(builder, item),
              ))
          ..formats.forEach((item) => builder.element(
                'format',
                namespace: Namespaces.dc,
                nest: () => _writeString(builder, item),
              ))
          ..identifiers.forEach((item) => builder.element(
                'identifier',
                namespace: Namespaces.dc,
                nest: () {
                  _writeId(builder, item);

                  if (version == EpubVersion.epub2 && item.scheme != null) {
                    builder.attribute(
                      'scheme',
                      item.scheme!,
                      namespace: Namespaces.opf,
                    );
                  }

                  builder.text(item.identifier!);
                },
              ))
          ..languages.forEach((item) => builder.element(
                'language',
                namespace: Namespaces.dc,
                nest: () => _writeString(builder, item),
              ))
          ..publishers.forEach((item) => builder.element(
                'publisher',
                namespace: Namespaces.dc,
                nest: () => _writeTranslatedString(builder, item),
              ))
          ..relations.forEach((item) => builder.element(
                'relation',
                namespace: Namespaces.dc,
                nest: () => _writeTranslatedString(builder, item),
              ))
          ..rights.forEach((item) => builder.element(
                'rights',
                namespace: Namespaces.dc,
                nest: () => _writeTranslatedString(builder, item),
              ))
          ..sources.forEach((item) => builder.element(
                'source',
                namespace: Namespaces.dc,
                nest: () => _writeString(builder, item),
              ))
          ..subjects.forEach((item) => builder.element(
                'subject',
                namespace: Namespaces.dc,
                nest: () => _writeTranslatedString(builder, item),
              ))
          ..titles.forEach((item) => builder.element(
                'title',
                namespace: Namespaces.dc,
                nest: () => _writeTranslatedString(builder, item),
              ))
          ..types.forEach((item) => builder.element(
                'type',
                namespace: Namespaces.dc,
                nest: () => _writeString(builder, item),
              ));

        meta.metaItems.forEach(
          (item) => builder.element('meta', nest: () {
            _writeId(builder, item);

            for (final attribute in item.attributes.entries) {
              builder.attribute(attribute.key, attribute.value);
            }

            if (item.textContent != null && item.textContent!.isNotEmpty) {
              builder.text(item.textContent!);
            }
          }),
        );
      },
    );
  }
}
