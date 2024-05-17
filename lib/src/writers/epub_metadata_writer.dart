import 'package:epub_editor/src/schema/opf/epub_metadata.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_contributor.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_field.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_string.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_translated_string.dart';
import 'package:epub_editor/src/schema/opf/epub_version.dart';
import 'package:xml/src/xml/builder.dart' show XmlBuilder;

class EpubMetadataWriter {
  static const _dc_namespace = 'http://purl.org/dc/elements/1.1/';
  static const _opf_namespace = 'http://www.idpf.org/2007/opf';

  static void _writeId(XmlBuilder builder, EpubMetadataField item) {
    if (item.id != null) {
      builder.attribute('id', item.id!);
    }
  }

  static void _writeContributor(
    XmlBuilder builder,
    EpubMetadataContributor item,
  ) {
    _writeId(builder, item);

    if (item.role != null) {
      builder.attribute(
        'role',
        item.role!,
        namespace: _opf_namespace,
      );
    }

    if (item.fileAs != null) {
      builder.attribute(
        'file-as',
        item.fileAs!,
        namespace: _opf_namespace,
      );
    }

    if (item.dir != null) {
      builder.attribute('dir', item.dir!);
    }

    if (item.lang != null) {
      builder.attribute(
        'xml:lang',
        item.lang!,
        namespace: 'xml',
      );
    }

    builder.text(item.name!);
  }

  static void _writeString(XmlBuilder builder, EpubMetadataString item) {
    _writeId(builder, item);
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
      builder.attribute(
        'lang',
        item.lang!,
        namespace: 'xml',
      );
    }

    builder.text(item.value!);
  }

  static void writeMetadata(
    XmlBuilder builder,
    EpubMetadata? meta,
    EpubVersion? version,
  ) {
    builder.element('metadata', namespaces: {
      _opf_namespace: 'opf',
      _dc_namespace: 'dc',
    }, nest: () {
      meta!
        ..contributors?.forEach((item) => builder.element(
              'contributor',
              namespace: _dc_namespace,
              nest: () => _writeContributor(builder, item),
            ))
        ..coverages?.forEach((item) => builder.element(
              'coverage',
              namespace: _dc_namespace,
              nest: () => _writeTranslatedString(builder, item),
            ))
        ..coverages?.forEach((item) => builder.element(
              'coverage',
              namespace: _dc_namespace,
              nest: () => _writeTranslatedString(builder, item),
            ))
        ..creators?.forEach((item) => builder.element(
              'creator',
              namespace: _dc_namespace,
              nest: () => _writeContributor(builder, item),
            ))
        ..dates?.forEach((item) =>
            builder.element('date', namespace: _dc_namespace, nest: () {
              _writeId(builder, item);

              if (item.event != null) {
                builder.attribute(
                  'event',
                  item.event!,
                  namespace: _opf_namespace,
                );
              }

              builder.text(item.date!);
            }))
        ..descriptions?.forEach((item) => builder.element(
              'description',
              namespace: _dc_namespace,
              nest: () => _writeTranslatedString(builder, item),
            ))
        ..formats?.forEach((item) => builder.element(
              'format',
              namespace: _dc_namespace,
              nest: () => _writeString(builder, item),
            ))
        ..identifiers?.forEach((item) =>
            builder.element('identifier', namespace: _dc_namespace, nest: () {
              _writeId(builder, item);

              if (item.scheme != null) {
                builder.attribute(
                  'scheme',
                  item.scheme!,
                  namespace: _opf_namespace,
                );
              }

              builder.text(item.identifier!);
            }))
        ..languages?.forEach((item) => builder.element(
              'language',
              namespace: _dc_namespace,
              nest: () => _writeString(builder, item),
            ))
        ..publishers?.forEach((item) => builder.element(
              'publisher',
              namespace: _dc_namespace,
              nest: () => _writeTranslatedString(builder, item),
            ))
        ..relations?.forEach((item) => builder.element(
              'relation',
              namespace: _dc_namespace,
              nest: () => _writeTranslatedString(builder, item),
            ))
        ..rights?.forEach((item) => builder.element(
              'rights',
              namespace: _dc_namespace,
              nest: () => _writeTranslatedString(builder, item),
            ))
        ..sources?.forEach((item) => builder.element(
              'source',
              namespace: _dc_namespace,
              nest: () => _writeString(builder, item),
            ))
        ..subjects?.forEach((item) => builder.element(
              'subject',
              namespace: _dc_namespace,
              nest: () => _writeTranslatedString(builder, item),
            ))
        ..titles?.forEach((item) => builder.element(
              'title',
              namespace: _dc_namespace,
              nest: () => _writeTranslatedString(builder, item),
            ))
        ..types?.forEach((item) => builder.element(
              'type',
              namespace: _dc_namespace,
              nest: () => _writeString(builder, item),
            ));

      // if (meta.publishers != null) {
      //   builder.element(
      //     'description',
      //     namespace: _dc_namespace,
      //     nest: meta.publishers,
      //   );
      // }
    });
  }
}
