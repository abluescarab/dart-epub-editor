import 'package:epub_editor/src/schema/opf/epub_metadata.dart';
import 'package:epub_editor/src/schema/opf/epub_version.dart';
import 'package:xml/src/xml/builder.dart' show XmlBuilder;

class EpubMetadataWriter {
  static const _dc_namespace = 'http://purl.org/dc/elements/1.1/';
  static const _opf_namespace = 'http://www.idpf.org/2007/opf';

  static void writeMetadata(
      XmlBuilder builder, EpubMetadata? meta, EpubVersion? version) {
    builder.element('metadata',
        namespaces: {_opf_namespace: 'opf', _dc_namespace: 'dc'}, nest: () {
      meta!
        ..contributors?.forEach((item) =>
            builder.element('contributor', namespace: _dc_namespace, nest: () {
              if (item.role != null) {
                builder.attribute('role', item.role!,
                    namespace: _opf_namespace);
              }
              if (item.fileAs != null) {
                builder.attribute('file-as', item.fileAs!,
                    namespace: _opf_namespace);
              }
              builder.text(item.contributor!);
            }))
        ..coverages?.forEach((item) =>
            builder.element('coverage', namespace: _dc_namespace, nest: item))
        ..creators?.forEach((item) =>
            builder.element('creator', namespace: _dc_namespace, nest: () {
              if (item.role != null) {
                builder.attribute('role', item.role!,
                    namespace: _opf_namespace);
              }
              if (item.fileAs != null) {
                builder.attribute('file-as', item.fileAs!,
                    namespace: _opf_namespace);
              }
              builder.text(item.creator!);
            }))
        ..dates?.forEach((date) =>
            builder.element('date', namespace: _dc_namespace, nest: () {
              if (date.event != null) {
                builder.attribute('event', date.event!,
                    namespace: _opf_namespace);
              }
              builder.text(date.date!);
            }))
        ..formats?.forEach((format) =>
            builder.element('format', namespace: _dc_namespace, nest: format))
        ..identifiers?.forEach((id) =>
            builder.element('identifier', namespace: _dc_namespace, nest: () {
              if (id.id != null) builder.attribute('id', id.id!);
              if (id.scheme != null) {
                builder.attribute('scheme', id.scheme!,
                    namespace: _opf_namespace);
              }
              builder.text(id.identifier!);
            }))
        ..languages?.forEach((item) =>
            builder.element('language', namespace: _dc_namespace, nest: item))
        ..metaItems?.forEach(
          (metaitem) => builder.element(
            'meta',
            nest: () {
              if (version == EpubVersion.epub2) {
                if (metaitem.name != null) {
                  builder.attribute('name', metaitem.name!);
                }
                if (metaitem.textContent != null) {
                  builder.attribute('content', metaitem.textContent!);
                }
              } else if (version == EpubVersion.epub3) {
                if (metaitem.id != null) {
                  builder.attribute('id', metaitem.id!);
                }
                if (metaitem.refines != null) {
                  builder.attribute('refines', metaitem.refines!);
                }
                if (metaitem.property != null) {
                  builder.attribute('property', metaitem.property!);
                }
                if (metaitem.scheme != null) {
                  builder.attribute('scheme', metaitem.scheme!);
                }
              }
            },
          ),
        )
        ..publishers?.forEach((item) =>
            builder.element('publisher', namespace: _dc_namespace, nest: item))
        ..relations?.forEach((item) =>
            builder.element('relation', namespace: _dc_namespace, nest: item))
        ..rights?.forEach((item) =>
            builder.element('rights', namespace: _dc_namespace, nest: item))
        ..sources?.forEach((item) =>
            builder.element('source', namespace: _dc_namespace, nest: item))
        ..subjects?.forEach((item) =>
            builder.element('subject', namespace: _dc_namespace, nest: item))
        ..titles?.forEach((item) =>
            builder.element('title', nest: item, namespace: _dc_namespace))
        ..types?.forEach((type) =>
            builder.element('type', namespace: _dc_namespace, nest: type));

      if (meta.publishers != null) {
        builder.element('description',
            namespace: _dc_namespace, nest: meta.publishers);
      }
    });
  }
}
