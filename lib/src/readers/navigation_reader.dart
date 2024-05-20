import 'dart:async';

import 'package:archive/archive.dart';
import 'dart:convert' as convert;
import 'package:collection/collection.dart' show IterableExtension;
import 'package:epub_editor/src/schema/navigation/epub_navigation_content.dart';
import 'package:epub_editor/src/schema/opf/epub_version.dart';
import 'package:epub_editor/src/utils/namespaces.dart';
import 'package:epub_editor/src/utils/value_or_inner_text.dart';
import 'package:xml/xml.dart' as xml;
import 'package:path/path.dart' as path;

import '../schema/navigation/epub_navigation.dart';
import '../schema/navigation/epub_navigation_doc_author.dart';
import '../schema/navigation/epub_navigation_doc_title.dart';
import '../schema/navigation/epub_navigation_head.dart';
import '../schema/navigation/epub_navigation_head_meta.dart';
import '../schema/navigation/epub_navigation_label.dart';
import '../schema/navigation/epub_navigation_list.dart';
import '../schema/navigation/epub_navigation_map.dart';
import '../schema/navigation/epub_navigation_page_list.dart';
import '../schema/navigation/epub_navigation_page_target.dart';
import '../schema/navigation/epub_navigation_page_target_type.dart';
import '../schema/navigation/epub_navigation_point.dart';
import '../schema/navigation/epub_navigation_target.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_package.dart';
import '../utils/enum_from_string.dart';
import '../utils/zip_path_utils.dart';

// ignore: omit_local_variable_types

class NavigationReader {
  static String? _tocFileEntryPath;

  static Future<EpubNavigation> readNavigation(Archive epubArchive,
      String contentDirectoryPath, EpubPackage package) async {
    final result = EpubNavigation();

    if (package.version == EpubVersion.epub2) {
      final tocId = package.spine!.tableOfContents;
      if (tocId == null || tocId.isEmpty) {
        throw Exception('EPUB parsing error: TOC ID is empty.');
      }

      final tocManifestItem =
          package.manifest!.items!.cast<EpubManifestItem?>().firstWhere(
                (EpubManifestItem? item) =>
                    item!.id!.toLowerCase() == tocId.toLowerCase(),
                orElse: () => null,
              );

      if (tocManifestItem == null) {
        throw Exception(
            'EPUB parsing error: TOC item $tocId not found in EPUB manifest.');
      }

      _tocFileEntryPath =
          ZipPathUtils.combine(contentDirectoryPath, tocManifestItem.href);
      final tocFileEntry = epubArchive.files.cast<ArchiveFile?>().firstWhere(
          (ArchiveFile? file) =>
              file!.name.toLowerCase() == _tocFileEntryPath!.toLowerCase(),
          orElse: () => null);
      if (tocFileEntry == null) {
        throw Exception(
            'EPUB parsing error: TOC file $_tocFileEntryPath not found in archive.');
      }

      final containerDocument =
          xml.XmlDocument.parse(convert.utf8.decode(tocFileEntry.content));

      final ncxNode = containerDocument
          .findAllElements('ncx', namespace: Namespaces.ncx)
          .cast<xml.XmlElement?>()
          .firstWhere((xml.XmlElement? elem) => elem != null,
              orElse: () => null);
      if (ncxNode == null) {
        throw Exception(
            'EPUB parsing error: TOC file does not contain ncx element.');
      }

      final headNode = ncxNode
          .findAllElements('head', namespace: Namespaces.ncx)
          .cast<xml.XmlElement?>()
          .firstWhere((xml.XmlElement? elem) => elem != null,
              orElse: () => null);
      if (headNode == null) {
        throw Exception(
            'EPUB parsing error: TOC file does not contain head element.');
      }

      final navigationHead = readNavigationHead(headNode);
      result.head = navigationHead;
      final docTitleNode = ncxNode
          .findElements('docTitle', namespace: Namespaces.ncx)
          .cast<xml.XmlElement?>()
          .firstWhere((xml.XmlElement? elem) => elem != null,
              orElse: () => null);
      if (docTitleNode == null) {
        throw Exception(
            'EPUB parsing error: TOC file does not contain docTitle element.');
      }

      final navigationDocTitle = readNavigationDocTitle(docTitleNode);
      result.docTitle = navigationDocTitle;
      result.docAuthors = <EpubNavigationDocAuthor>[];
      ncxNode
          .findElements('docAuthor', namespace: Namespaces.ncx)
          .forEach((xml.XmlElement docAuthorNode) {
        final navigationDocAuthor = readNavigationDocAuthor(docAuthorNode);
        result.docAuthors!.add(navigationDocAuthor);
      });

      final navMapNode = ncxNode
          .findElements('navMap', namespace: Namespaces.ncx)
          .cast<xml.XmlElement?>()
          .firstWhere((xml.XmlElement? elem) => elem != null,
              orElse: () => null);
      if (navMapNode == null) {
        throw Exception(
            'EPUB parsing error: TOC file does not contain navMap element.');
      }

      final navMap = readNavigationMap(navMapNode);
      result.navMap = navMap;
      final pageListNode = ncxNode
          .findElements('pageList', namespace: Namespaces.ncx)
          .cast<xml.XmlElement?>()
          .firstWhere((xml.XmlElement? elem) => elem != null,
              orElse: () => null);
      if (pageListNode != null) {
        final pageList = readNavigationPageList(pageListNode);
        result.pageList = pageList;
      }

      result.navLists = <EpubNavigationList>[];
      ncxNode
          .findElements('navList', namespace: Namespaces.ncx)
          .forEach((xml.XmlElement navigationListNode) {
        final navigationList = readNavigationList(navigationListNode);
        result.navLists!.add(navigationList);
      });
    } else {
      //Version 3
      final tocManifestItem =
          package.manifest!.items!.cast<EpubManifestItem?>().firstWhere(
                (element) => element!.properties == 'nav',
                orElse: () => null,
              );

      if (tocManifestItem == null) {
        throw Exception(
          'EPUB parsing error: TOC item not found in EPUB manifest.',
        );
      }

      _tocFileEntryPath =
          ZipPathUtils.combine(contentDirectoryPath, tocManifestItem.href);

      final tocFileEntry = epubArchive.files.cast<ArchiveFile?>().firstWhere(
            (ArchiveFile? file) =>
                file!.name.toLowerCase() == _tocFileEntryPath!.toLowerCase(),
            orElse: () => null,
          );

      if (tocFileEntry == null) {
        throw Exception(
          'EPUB parsing error: TOC file $_tocFileEntryPath not found in archive.',
        );
      }

      //Get relative toc file path
      _tocFileEntryPath = ((_tocFileEntryPath!.split('/')..removeLast())
                ..removeAt(0))
              .join('/') +
          '/';

      final containerDocument =
          xml.XmlDocument.parse(convert.utf8.decode(tocFileEntry.content));

      final headNode = containerDocument
          .findAllElements('head')
          .cast<xml.XmlElement?>()
          .firstWhere((xml.XmlElement? elem) => elem != null,
              orElse: () => null);

      if (headNode == null) {
        throw Exception(
            'EPUB parsing error: TOC file does not contain head element.');
      }

      result.docTitle = EpubNavigationDocTitle();
      result.docTitle!.titles = package.metadata!.titles
          ?.map((titleElement) => titleElement.value ?? '')
          .toList();
//      result.docTitle.titles.add(headNode.findAllElements("title").firstWhere((element) =>  element != null, orElse: () => null).text.trim());

      result.docAuthors = <EpubNavigationDocAuthor>[];

      final navNode = containerDocument
          .findAllElements('nav')
          .cast<xml.XmlElement?>()
          .firstWhere((xml.XmlElement? elem) => elem != null,
              orElse: () => null);

      if (navNode == null) {
        throw Exception(
            'EPUB parsing error: TOC file does not contain head element.');
      }

      final navMapNode = navNode.findElements('ol').single;
      final navMap = readNavigationMapV3(navMapNode);

      result.navMap = navMap;

      //TODO : Implement pagesLists
//      xml.XmlElement pageListNode = ncxNode
//          .findElements("pageList", namespace: Namespaces.ncx)
//          .firstWhere((xml.XmlElement elem) => elem != null,
//          orElse: () => null);
//      if (pageListNode != null) {
//        EpubNavigationPageList pageList = readNavigationPageList(pageListNode);
//        result.pageList = pageList;
//      }
    }

    return result;
  }

  static EpubNavigationContent readNavigationContent(
      xml.XmlElement navigationContentNode) {
    final result = EpubNavigationContent();
    navigationContentNode.attributes
        .forEach((xml.XmlAttribute navigationContentNodeAttribute) {
      final attributeValue = navigationContentNodeAttribute.value;
      switch (navigationContentNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result.id = attributeValue;
          break;
        case 'src':
          result.source = attributeValue;
          break;
      }
    });
    if (result.source == null || result.source!.isEmpty) {
      throw Exception(
          'Incorrect EPUB navigation content: content source is missing.');
    }

    return result;
  }

  static EpubNavigationContent readNavigationContentV3(
      xml.XmlElement navigationContentNode) {
    final result = EpubNavigationContent();
    navigationContentNode.attributes
        .forEach((xml.XmlAttribute navigationContentNodeAttribute) {
      final attributeValue = navigationContentNodeAttribute.value;
      switch (navigationContentNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result.id = attributeValue;
          break;
        case 'href':
          if (_tocFileEntryPath!.length < 2 ||
              attributeValue.startsWith(_tocFileEntryPath!)) {
            result.source = attributeValue;
          } else {
            result.source = path.normalize(_tocFileEntryPath! + attributeValue);

            // if running on Windows, path.normalize() replaces / with \
            if (_tocFileEntryPath!.contains('/')) {
              result.source = result.source?.replaceAll('\\', '/');
            }
          }

          break;
      }
    });

    // element with span, the content will be null;
    // if (result.source == null || result.source!.isEmpty) {
    //   throw Exception(
    //       'Incorrect EPUB navigation content: content source is missing.');
    // }
    return result;
  }

  static String extractContentPath(String _tocFileEntryPath, String ref) {
    if (!_tocFileEntryPath.endsWith('/')) {
      _tocFileEntryPath = _tocFileEntryPath + '/';
    }
    var r = _tocFileEntryPath + ref;
    r = r.replaceAll('/\./', '/');
    r = r.replaceAll(RegExp(r'/[^/]+/\.\./'), '/');
    r = r.replaceAll(RegExp(r'^[^/]+/\.\./'), '');
    return r;
  }

  static EpubNavigationDocAuthor readNavigationDocAuthor(
      xml.XmlElement docAuthorNode) {
    final result = EpubNavigationDocAuthor();
    result.authors = <String>[];
    docAuthorNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement textNode) {
      if (textNode.name.local.toLowerCase() == 'text') {
        result.authors!.add(valueOrInnerText(textNode));
      }
    });
    return result;
  }

  static EpubNavigationDocTitle readNavigationDocTitle(
      xml.XmlElement docTitleNode) {
    final result = EpubNavigationDocTitle();
    result.titles = <String>[];
    docTitleNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement textNode) {
      if (textNode.name.local.toLowerCase() == 'text') {
        result.titles!.add(valueOrInnerText(textNode));
      }
    });
    return result;
  }

  static EpubNavigationHead readNavigationHead(xml.XmlElement headNode) {
    final result = EpubNavigationHead();
    result.metadata = <EpubNavigationHeadMeta>[];

    headNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement metaNode) {
      if (metaNode.name.local.toLowerCase() == 'meta') {
        final meta = EpubNavigationHeadMeta();
        metaNode.attributes.forEach((xml.XmlAttribute metaNodeAttribute) {
          final attributeValue = metaNodeAttribute.value;
          switch (metaNodeAttribute.name.local.toLowerCase()) {
            case 'name':
              meta.name = attributeValue;
              break;
            case 'content':
              meta.content = attributeValue;
              break;
            case 'scheme':
              meta.scheme = attributeValue;
              break;
          }
        });

        if (meta.name == null || meta.name!.isEmpty) {
          throw Exception(
              'Incorrect EPUB navigation meta: meta name is missing.');
        }
        if (meta.content == null) {
          throw Exception(
              'Incorrect EPUB navigation meta: meta content is missing.');
        }

        result.metadata!.add(meta);
      }
    });
    return result;
  }

  static EpubNavigationLabel readNavigationLabel(
      xml.XmlElement navigationLabelNode) {
    final result = EpubNavigationLabel();

    final navigationLabelTextNode = navigationLabelNode
        .findElements('text', namespace: navigationLabelNode.name.namespaceUri)
        .firstWhereOrNull((xml.XmlElement? elem) => elem != null);
    if (navigationLabelTextNode == null) {
      throw Exception(
          'Incorrect EPUB navigation label: label text element is missing.');
    }

    result.text = valueOrInnerText(navigationLabelTextNode);

    return result;
  }

  static EpubNavigationLabel readNavigationLabelV3(
      xml.XmlElement navigationLabelNode) {
    final result = EpubNavigationLabel();
    result.text = valueOrInnerText(navigationLabelNode).trim();
    return result;
  }

  static EpubNavigationList readNavigationList(
      xml.XmlElement navigationListNode) {
    final result = EpubNavigationList();
    navigationListNode.attributes
        .forEach((xml.XmlAttribute navigationListNodeAttribute) {
      final attributeValue = navigationListNodeAttribute.value;
      switch (navigationListNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result.id = attributeValue;
          break;
        case 'class':
          result.classAttribute = attributeValue;
          break;
      }
    });
    navigationListNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationListChildNode) {
      switch (navigationListChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          final navigationLabel = readNavigationLabel(navigationListChildNode);
          result.navigationLabels!.add(navigationLabel);
          break;
        case 'navtarget':
          final navigationTarget =
              readNavigationTarget(navigationListChildNode);
          result.navigationTargets!.add(navigationTarget);
          break;
      }
    });
// if (result.navigationLabels!.isEmpty) {
//   throw Exception(
//       'Incorrect EPUB navigation page target: at least one navLabel element is required.');
// }
    return result;
  }

  static EpubNavigationMap readNavigationMap(xml.XmlElement navigationMapNode) {
    final result = EpubNavigationMap();
    result.points = <EpubNavigationPoint>[];
    navigationMapNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationPointNode) {
      if (navigationPointNode.name.local.toLowerCase() == 'navpoint') {
        final navigationPoint = readNavigationPoint(navigationPointNode);
        result.points!.add(navigationPoint);
      }
    });
    return result;
  }

  static EpubNavigationMap readNavigationMapV3(
      xml.XmlElement navigationMapNode) {
    final result = EpubNavigationMap();
    result.points = <EpubNavigationPoint>[];
    navigationMapNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationPointNode) {
      if (navigationPointNode.name.local.toLowerCase() == 'li') {
        final navigationPoint = readNavigationPointV3(navigationPointNode);
        result.points!.add(navigationPoint);
      }
    });
    return result;
  }

  static EpubNavigationPageList readNavigationPageList(
      xml.XmlElement navigationPageListNode) {
    final result = EpubNavigationPageList();
    result.targets = <EpubNavigationPageTarget>[];
    navigationPageListNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement pageTargetNode) {
      if (pageTargetNode.name.local == 'pageTarget') {
        final pageTarget = readNavigationPageTarget(pageTargetNode);
        result.targets!.add(pageTarget);
      }
    });

    return result;
  }

  static EpubNavigationPageTarget readNavigationPageTarget(
      xml.XmlElement navigationPageTargetNode) {
    final result = EpubNavigationPageTarget();
    result.navigationLabels = <EpubNavigationLabel>[];
    navigationPageTargetNode.attributes
        .forEach((xml.XmlAttribute navigationPageTargetNodeAttribute) {
      final attributeValue = navigationPageTargetNodeAttribute.value;
      switch (navigationPageTargetNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result.id = attributeValue;
          break;
        case 'value':
          result.value = attributeValue;
          break;
        case 'type':
          final converter = EnumFromString<EpubNavigationPageTargetType>(
              EpubNavigationPageTargetType.values);
          final type = converter.get(attributeValue);
          result.type = type;
          break;
        case 'class':
          result.classAttribute = attributeValue;
          break;
        case 'playorder':
          result.playOrder = attributeValue;
          break;
      }
    });
    if (result.type == EpubNavigationPageTargetType.undefined) {
      throw Exception(
          'Incorrect EPUB navigation page target: page target type is missing.');
    }

    navigationPageTargetNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationPageTargetChildNode) {
      switch (navigationPageTargetChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          final navigationLabel =
              readNavigationLabel(navigationPageTargetChildNode);
          result.navigationLabels!.add(navigationLabel);
          break;
        case 'content':
          final content = readNavigationContent(navigationPageTargetChildNode);
          result.content = content;
          break;
      }
    });
    if (result.navigationLabels!.isEmpty) {
      throw Exception(
          'Incorrect EPUB navigation page target: at least one navLabel element is required.');
    }

    return result;
  }

  static EpubNavigationPoint readNavigationPoint(
      xml.XmlElement navigationPointNode) {
    final result = EpubNavigationPoint();
    navigationPointNode.attributes
        .forEach((xml.XmlAttribute navigationPointNodeAttribute) {
      final attributeValue = navigationPointNodeAttribute.value;
      switch (navigationPointNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result.id = attributeValue;
          break;
        case 'class':
          result.classAttribute = attributeValue;
          break;
        case 'playorder':
          result.playOrder = attributeValue;
          break;
      }
    });
    if (result.id == null || result.id!.isEmpty) {
      throw Exception('Incorrect EPUB navigation point: point ID is missing.');
    }

    result.navigationLabels = <EpubNavigationLabel>[];
    result.childNavigationPoints = <EpubNavigationPoint>[];
    navigationPointNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationPointChildNode) {
      switch (navigationPointChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          final navigationLabel = readNavigationLabel(navigationPointChildNode);
          result.navigationLabels!.add(navigationLabel);
          break;
        case 'content':
          final content = readNavigationContent(navigationPointChildNode);
          result.content = content;
          break;
        case 'navpoint':
          final childNavigationPoint =
              readNavigationPoint(navigationPointChildNode);
          result.childNavigationPoints!.add(childNavigationPoint);
          break;
      }
    });

    if (result.navigationLabels!.isEmpty) {
      throw Exception(
          'EPUB parsing error: navigation point ${result.id} should contain at least one navigation label.');
    }
    if (result.content == null) {
      throw Exception(
          'EPUB parsing error: navigation point ${result.id} should contain content.');
    }

    return result;
  }

  static EpubNavigationPoint readNavigationPointV3(
      xml.XmlElement navigationPointNode) {
    final result = EpubNavigationPoint();

    result.navigationLabels = <EpubNavigationLabel>[];
    result.childNavigationPoints = <EpubNavigationPoint>[];
    navigationPointNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationPointChildNode) {
      switch (navigationPointChildNode.name.local.toLowerCase()) {
        case 'a':
        case 'span':
          final navigationLabel =
              readNavigationLabelV3(navigationPointChildNode);
          result.navigationLabels!.add(navigationLabel);
          final content = readNavigationContentV3(navigationPointChildNode);
          result.content = content;
          break;
        case 'ol':
          readNavigationMapV3(navigationPointChildNode)
              .points!
              .forEach((point) {
            result.childNavigationPoints!.add(point);
          });
          break;
      }
    });

    if (result.navigationLabels!.isEmpty) {
      throw Exception(
          'EPUB parsing error: navigation point ${result.id} should contain at least one navigation label.');
    }
    if (result.content == null) {
      throw Exception(
          'EPUB parsing error: navigation point ${result.id} should contain content.');
    }

    return result;
  }

  static EpubNavigationTarget readNavigationTarget(
      xml.XmlElement navigationTargetNode) {
    final result = EpubNavigationTarget();
    navigationTargetNode.attributes
        .forEach((xml.XmlAttribute navigationPageTargetNodeAttribute) {
      final attributeValue = navigationPageTargetNodeAttribute.value;
      switch (navigationPageTargetNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result.id = attributeValue;
          break;
        case 'value':
          result.value = attributeValue;
          break;
        case 'class':
          result.classAttribute = attributeValue;
          break;
        case 'playorder':
          result.playOrder = attributeValue;
          break;
      }
    });
    if (result.id == null || result.id!.isEmpty) {
      throw Exception(
          'Incorrect EPUB navigation target: navigation target ID is missing.');
    }

    navigationTargetNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationTargetChildNode) {
      switch (navigationTargetChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          final navigationLabel =
              readNavigationLabel(navigationTargetChildNode);
          result.navigationLabels!.add(navigationLabel);
          break;
        case 'content':
          final content = readNavigationContent(navigationTargetChildNode);
          result.content = content;
          break;
      }
    });
    if (result.navigationLabels!.isEmpty) {
      throw Exception(
          'Incorrect EPUB navigation target: at least one navLabel element is required.');
    }

    return result;
  }
}
