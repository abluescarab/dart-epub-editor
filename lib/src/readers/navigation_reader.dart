// ignore: omit_local_variable_types

import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_content.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_doc_author.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_doc_title.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_head.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_head_meta.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_label.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_list.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_map.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_page_list.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_page_target.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_page_target_type.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_point.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_target.dart';
import 'package:epub_editor/src/schema/opf/epub_manifest_item.dart';
import 'package:epub_editor/src/schema/opf/epub_package.dart';
import 'package:epub_editor/src/schema/opf/epub_version.dart';
import 'package:epub_editor/src/utils/enum_from_string.dart';
import 'package:epub_editor/src/utils/namespaces.dart';
import 'package:epub_editor/src/utils/value_or_inner_text.dart';
import 'package:epub_editor/src/utils/zip_path_utils.dart';
import 'package:path/path.dart' as path;
import 'package:xml/xml.dart';

class NavigationReader {
  static String? _tocFileEntryPath;

  static Future<EpubNavigation> readNavigation(
    Archive epubArchive,
    String contentDirectoryPath,
    EpubPackage package,
  ) async {
    EpubNavigation result;

    if (package.version == EpubVersion.epub2) {
      final tocId = package.spine!.tableOfContents;

      if (tocId == null || tocId.isEmpty) {
        throw Exception('EPUB parsing error: TOC ID is empty.');
      }

      final tocManifestItem = package.manifest!.items
          ?.cast<EpubManifestItem?>()
          .firstWhereOrNull(
              (item) => item!.id!.toLowerCase() == tocId.toLowerCase());

      if (tocManifestItem == null) {
        throw Exception(
          'EPUB parsing error: TOC item $tocId not found in EPUB manifest.',
        );
      }

      _tocFileEntryPath = ZipPathUtils.combine(
        contentDirectoryPath,
        tocManifestItem.href,
      );

      final tocFileEntry = epubArchive.files
          .cast<ArchiveFile?>()
          .firstWhereOrNull((file) =>
              file!.name.toLowerCase() == _tocFileEntryPath!.toLowerCase());

      if (tocFileEntry == null) {
        throw Exception(
            'EPUB parsing error: TOC file $_tocFileEntryPath not found in '
            'archive.');
      }

      final ncxNode = XmlDocument.parse(utf8.decode(tocFileEntry.content))
          .findAllElements('ncx', namespace: Namespaces.ncx)
          .cast<XmlElement?>()
          .firstWhereOrNull((elem) => elem != null);

      if (ncxNode == null) {
        throw Exception(
          'EPUB parsing error: TOC file does not contain ncx element.',
        );
      }

      final headNode = ncxNode
          .findAllElements('head', namespace: Namespaces.ncx)
          .cast<XmlElement?>()
          .firstWhereOrNull((elem) => elem != null);

      if (headNode == null) {
        throw Exception(
          'EPUB parsing error: TOC file does not contain head element.',
        );
      }

      final docTitleNode = ncxNode
          .findElements('docTitle', namespace: Namespaces.ncx)
          .cast<XmlElement?>()
          .firstWhereOrNull((elem) => elem != null);

      if (docTitleNode == null) {
        throw Exception(
          'EPUB parsing error: TOC file does not contain docTitle element.',
        );
      }

      final docAuthors = <EpubNavigationDocAuthor>[];

      ncxNode.findElements('docAuthor', namespace: Namespaces.ncx).forEach(
            (docAuthorNode) => docAuthors.add(
              readNavigationDocAuthor(docAuthorNode),
            ),
          );

      final navMapNode = ncxNode
          .findElements('navMap', namespace: Namespaces.ncx)
          .cast<XmlElement?>()
          .firstWhereOrNull((elem) => elem != null);

      if (navMapNode == null) {
        throw Exception(
          'EPUB parsing error: TOC file does not contain navMap element.',
        );
      }

      final pageListNode = ncxNode
          .findElements('pageList', namespace: Namespaces.ncx)
          .cast<XmlElement?>()
          .firstWhereOrNull((elem) => elem != null);

      final navLists = <EpubNavigationList>[];

      ncxNode.findElements('navList', namespace: Namespaces.ncx).forEach(
            (navigationListNode) => navLists.add(
              readNavigationList(navigationListNode),
            ),
          );

      result = EpubNavigation(
        docAuthors: docAuthors,
        pageList:
            pageListNode != null ? readNavigationPageList(pageListNode) : null,
        head: readNavigationHead(headNode),
        docTitle: readNavigationDocTitle(docTitleNode),
        navMap: readNavigationMap(navMapNode),
        navLists: navLists,
      );
    } else {
      //Version 3
      final tocManifestItem = package.manifest!.items
          ?.cast<EpubManifestItem?>()
          .firstWhereOrNull((element) => element!.properties == 'nav');

      if (tocManifestItem == null) {
        throw Exception(
          'EPUB parsing error: TOC item not found in EPUB manifest.',
        );
      }

      _tocFileEntryPath = ZipPathUtils.combine(
        contentDirectoryPath,
        tocManifestItem.href,
      );

      final tocFileEntry = epubArchive.files
          .cast<ArchiveFile?>()
          .firstWhereOrNull((file) =>
              file!.name.toLowerCase() == _tocFileEntryPath!.toLowerCase());

      if (tocFileEntry == null) {
        throw Exception(
          'EPUB parsing error: TOC file $_tocFileEntryPath not found in '
          'archive.',
        );
      }

      //Get relative toc file path
      _tocFileEntryPath = ((_tocFileEntryPath!.split('/')..removeLast())
                ..removeAt(0))
              .join('/') +
          '/';

      final containerDocument = XmlDocument.parse(
        utf8.decode(tocFileEntry.content),
      );

      final headNode = containerDocument
          .findAllElements('head')
          .cast<XmlElement?>()
          .firstWhereOrNull((elem) => elem != null);

      if (headNode == null) {
        throw Exception(
          'EPUB parsing error: TOC file does not contain head element.',
        );
      }

      final navNode = containerDocument
          .findAllElements('nav')
          .cast<XmlElement?>()
          .firstWhereOrNull((elem) => elem != null);

      if (navNode == null) {
        throw Exception(
          'EPUB parsing error: TOC file does not contain head element.',
        );
      }

      result = EpubNavigation(
        docTitle: EpubNavigationDocTitle(
          titles: package.metadata?.titles
              ?.map((titleElement) => titleElement.value ?? '')
              .toList(),
        ),
        docAuthors: [],
        navMap: readNavigationMapV3(navNode.findElements('ol').single),
      );
    }

    return result;
  }

  static EpubNavigationContent readNavigationContent(
    XmlElement navigationContentNode,
  ) {
    final result = EpubNavigationContent();

    navigationContentNode.attributes.forEach((navigationContentNodeAttribute) {
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
        'Incorrect EPUB navigation content: content source is missing.',
      );
    }

    return result;
  }

  static EpubNavigationContent readNavigationContentV3(
    XmlElement navigationContentNode,
  ) {
    final result = EpubNavigationContent();

    navigationContentNode.attributes.forEach((navigationContentNodeAttribute) {
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

    return result;
  }

  static String extractContentPath(String tocFileEntryPath, String ref) {
    if (!tocFileEntryPath.endsWith('/')) {
      tocFileEntryPath = tocFileEntryPath + '/';
    }

    return (tocFileEntryPath + ref)
      ..replaceAll('/\./', '/')
      ..replaceAll(RegExp(r'/[^/]+/\.\./'), '/')
      ..replaceAll(RegExp(r'^[^/]+/\.\./'), '');
  }

  static EpubNavigationDocAuthor readNavigationDocAuthor(
    XmlElement docAuthorNode,
  ) =>
      EpubNavigationDocAuthor(
          authors: docAuthorNode.children
              .where((child) =>
                  child is XmlElement &&
                  child.name.local.toLowerCase() == 'text')
              .map((e) => valueOrInnerText(e))
              .toList());

  static EpubNavigationDocTitle readNavigationDocTitle(
    XmlElement docTitleNode,
  ) =>
      EpubNavigationDocTitle(
          titles: docTitleNode.children
              .where((child) =>
                  child is XmlElement &&
                  child.name.local.toLowerCase() == 'text')
              .map((e) => valueOrInnerText(e))
              .toList());

  static EpubNavigationHead readNavigationHead(XmlElement headNode) =>
      EpubNavigationHead(
          metadata: headNode.children
              .where((child) =>
                  child is XmlElement &&
                  child.name.local.toLowerCase() == 'meta')
              .map((e) {
        final meta = EpubNavigationHeadMeta();

        e.attributes.forEach((metaNodeAttribute) {
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
            'Incorrect EPUB navigation meta: meta name is missing.',
          );
        }

        if (meta.content == null) {
          throw Exception(
            'Incorrect EPUB navigation meta: meta content is missing.',
          );
        }

        return meta;
      }).toList());

  static EpubNavigationLabel readNavigationLabel(
    XmlElement navigationLabelNode,
  ) {
    final navigationLabelTextNode = navigationLabelNode
        .findElements('text', namespace: navigationLabelNode.name.namespaceUri)
        .firstOrNull;

    if (navigationLabelTextNode == null) {
      throw Exception(
        'Incorrect EPUB navigation label: label text element is missing.',
      );
    }

    return EpubNavigationLabel(
      text: valueOrInnerText(navigationLabelTextNode),
    );
  }

  static EpubNavigationLabel readNavigationLabelV3(
    XmlElement navigationLabelNode,
  ) =>
      EpubNavigationLabel(text: valueOrInnerText(navigationLabelNode).trim());

  static EpubNavigationList readNavigationList(XmlElement navigationListNode) {
    final result = EpubNavigationList();

    navigationListNode.attributes.forEach((navigationListNodeAttribute) {
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
        .whereType<XmlElement>()
        .forEach((navigationListChildNode) {
      switch (navigationListChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          result.navigationLabels!.add(
            readNavigationLabel(navigationListChildNode),
          );
          break;
        case 'navtarget':
          result.navigationTargets!.add(
            readNavigationTarget(navigationListChildNode),
          );
          break;
      }
    });

    return result;
  }

  static EpubNavigationMap readNavigationMap(XmlElement navigationMapNode) {
    final result = EpubNavigationMap()..points = <EpubNavigationPoint>[];

    navigationMapNode.children
        .whereType<XmlElement>()
        .forEach((navigationPointNode) {
      if (navigationPointNode.name.local.toLowerCase() == 'navpoint') {
        result.points!.add(readNavigationPoint(navigationPointNode));
      }
    });

    return result;
  }

  static EpubNavigationMap readNavigationMapV3(XmlElement navigationMapNode) {
    final result = EpubNavigationMap()..points = <EpubNavigationPoint>[];

    navigationMapNode.children
        .whereType<XmlElement>()
        .forEach((navigationPointNode) {
      if (navigationPointNode.name.local.toLowerCase() == 'li') {
        result.points!.add(readNavigationPointV3(navigationPointNode));
      }
    });

    return result;
  }

  static EpubNavigationPageList readNavigationPageList(
    XmlElement navigationPageListNode,
  ) {
    final result = EpubNavigationPageList()
      ..targets = <EpubNavigationPageTarget>[];

    navigationPageListNode.children
        .whereType<XmlElement>()
        .forEach((pageTargetNode) {
      if (pageTargetNode.name.local == 'pageTarget') {
        result.targets!.add(readNavigationPageTarget(pageTargetNode));
      }
    });

    return result;
  }

  static EpubNavigationPageTarget readNavigationPageTarget(
    XmlElement navigationPageTargetNode,
  ) {
    final result = EpubNavigationPageTarget()
      ..navigationLabels = <EpubNavigationLabel>[];

    navigationPageTargetNode.attributes
        .forEach((navigationPageTargetNodeAttribute) {
      final attributeValue = navigationPageTargetNodeAttribute.value;

      switch (navigationPageTargetNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result.id = attributeValue;
          break;
        case 'value':
          result.value = attributeValue;
          break;
        case 'type':
          result.type = EnumFromString<EpubNavigationPageTargetType>(
            EpubNavigationPageTargetType.values,
          ).get(attributeValue);
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
        'Incorrect EPUB navigation page target: page target type is missing.',
      );
    }

    navigationPageTargetNode.children
        .whereType<XmlElement>()
        .forEach((navigationPageTargetChildNode) {
      switch (navigationPageTargetChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          result.navigationLabels!.add(
            readNavigationLabel(navigationPageTargetChildNode),
          );
          break;
        case 'content':
          result.content = readNavigationContent(navigationPageTargetChildNode);
          break;
      }
    });

    if (result.navigationLabels!.isEmpty) {
      throw Exception(
        'Incorrect EPUB navigation page target: at least one navLabel element '
        'is required.',
      );
    }

    return result;
  }

  static EpubNavigationPoint readNavigationPoint(
    XmlElement navigationPointNode,
  ) {
    final result = EpubNavigationPoint();

    navigationPointNode.attributes.forEach((navigationPointNodeAttribute) {
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

    result
      ..navigationLabels = <EpubNavigationLabel>[]
      ..childNavigationPoints = <EpubNavigationPoint>[];

    navigationPointNode.children
        .whereType<XmlElement>()
        .forEach((navigationPointChildNode) {
      switch (navigationPointChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          result.navigationLabels!.add(
            readNavigationLabel(navigationPointChildNode),
          );
          break;
        case 'content':
          result.content = readNavigationContent(navigationPointChildNode);
          break;
        case 'navpoint':
          result.childNavigationPoints!.add(
            readNavigationPoint(navigationPointChildNode),
          );
          break;
      }
    });

    if (result.navigationLabels!.isEmpty) {
      throw Exception(
        'EPUB parsing error: navigation point ${result.id} should contain at '
        'least one navigation label.',
      );
    }

    if (result.content == null) {
      throw Exception(
        'EPUB parsing error: navigation point ${result.id} should contain '
        'content.',
      );
    }

    return result;
  }

  static EpubNavigationPoint readNavigationPointV3(
    XmlElement navigationPointNode,
  ) {
    final result = EpubNavigationPoint()
      ..navigationLabels = <EpubNavigationLabel>[]
      ..childNavigationPoints = <EpubNavigationPoint>[];

    navigationPointNode.children
        .whereType<XmlElement>()
        .forEach((navigationPointChildNode) {
      switch (navigationPointChildNode.name.local.toLowerCase()) {
        case 'a':
        case 'span':
          result.navigationLabels!.add(
            readNavigationLabelV3(navigationPointChildNode),
          );
          result.content = readNavigationContentV3(navigationPointChildNode);
          break;
        case 'ol':
          readNavigationMapV3(navigationPointChildNode)
              .points!
              .forEach((point) => result.childNavigationPoints!.add(point));
          break;
      }
    });

    if (result.navigationLabels!.isEmpty) {
      throw Exception(
        'EPUB parsing error: navigation point ${result.id} should contain at '
        'least one navigation label.',
      );
    }

    if (result.content == null) {
      throw Exception(
        'EPUB parsing error: navigation point ${result.id} should contain '
        'content.',
      );
    }

    return result;
  }

  static EpubNavigationTarget readNavigationTarget(
    XmlElement navigationTargetNode,
  ) {
    final result = EpubNavigationTarget();

    navigationTargetNode.attributes
        .forEach((navigationPageTargetNodeAttribute) {
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
        'Incorrect EPUB navigation target: navigation target ID is missing.',
      );
    }

    navigationTargetNode.children
        .whereType<XmlElement>()
        .forEach((navigationTargetChildNode) {
      switch (navigationTargetChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          result.navigationLabels!.add(
            readNavigationLabel(navigationTargetChildNode),
          );
          break;
        case 'content':
          result.content = readNavigationContent(navigationTargetChildNode);
          break;
      }
    });

    if (result.navigationLabels!.isEmpty) {
      throw Exception(
        'Incorrect EPUB navigation target: at least one navLabel element is '
        'required.',
      );
    }

    return result;
  }
}
