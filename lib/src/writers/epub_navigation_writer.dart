import 'package:epub_editor/src/schema/navigation/epub_navigation.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_doc_title.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_head.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_map.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_point.dart';
import 'package:epub_editor/src/utils/namespaces.dart';
import 'package:xml/src/xml/builder.dart' show XmlBuilder;

class EpubNavigationWriter {
  static String writeNavigation(EpubNavigation navigation) {
    final builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element(
      'ncx',
      attributes: {
        'version': '2005-1',
        'lang': 'en',
      },
      nest: () {
        builder.namespace(Namespaces.ncx);

        _writeNavigationHead(builder, navigation.head!);
        _writeNavigationDocTitle(builder, navigation.docTitle!);
        _writeNavigationMap(builder, navigation.navMap!);
      },
    );

    return builder.buildDocument().toXmlString(pretty: true);
  }

  static void _writeNavigationDocTitle(
    XmlBuilder builder,
    EpubNavigationDocTitle title,
  ) {
    builder.element(
      'docTitle',
      nest: () => title.titles.forEach((element) => builder.text(element)),
    );
  }

  static void _writeNavigationHead(XmlBuilder builder, EpubNavigationHead head) {
    builder.element('head', nest: () {
      head.metadata.forEach((item) => builder.element(
            'meta',
            attributes: {
              'content': item.content!,
              'name': item.name!,
            },
          ));
    });
  }

  static void _writeNavigationMap(XmlBuilder builder, EpubNavigationMap map) {
    builder.element('navMap', nest: () {
      map.points.forEach((item) => _writeNavigationPoint(builder, item));
    });
  }

  static void _writeNavigationPoint(
    XmlBuilder builder,
    EpubNavigationPoint point,
  ) {
    builder.element('navPoint', attributes: {
      'id': point.id!,
      'playOrder': point.playOrder!,
    }, nest: () {
      point.navigationLabels.forEach((element) {
        builder.element('navLabel', nest: () {
          builder.element('text', nest: () => builder.text(element.text));
        });
      });

      builder.element('content', attributes: {'src': point.content!.source!});
    });
  }
}
