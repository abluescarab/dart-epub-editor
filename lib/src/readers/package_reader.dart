import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:epub_editor/src/schema/opf/epub_guide.dart';
import 'package:epub_editor/src/schema/opf/epub_guide_reference.dart';
import 'package:epub_editor/src/schema/opf/epub_manifest.dart';
import 'package:epub_editor/src/schema/opf/epub_manifest_item.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_alternate_script.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_contributor.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_date.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_identifier.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_meta.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_string.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_translated_string.dart';
import 'package:epub_editor/src/schema/opf/epub_package.dart';
import 'package:epub_editor/src/schema/opf/epub_spine.dart';
import 'package:epub_editor/src/schema/opf/epub_spine_item_ref.dart';
import 'package:epub_editor/src/schema/opf/epub_version.dart';
import 'package:epub_editor/src/utils/namespaces.dart';
import 'package:epub_editor/src/utils/value_or_inner_text.dart';
import 'package:xml/xml.dart';

class PackageReader {
  static Map<String, String> _readAttributes(
    List<XmlAttribute> attributes, {
    List<String>? exclude,
  }) {
    Map<String, String> result = {};

    final attrs = exclude == null
        ? attributes
        : attributes
            .where((element) => !exclude.contains(element.qualifiedName));

    attrs.forEach((element) {
      result[element.qualifiedName] = element.value;
    });

    return result;
  }

  static Map<String, String> _readNamespaces(List<XmlAttribute> attributes) {
    Map<String, String> namespaces = {};

    attributes
        .where((p0) => p0.qualifiedName.startsWith("xmlns"))
        .forEach((element) {
      // skip "opf" and "dc" which are added to the <metadata> element
      if (element.localName != "opf" && element.localName != "dc") {
        namespaces[element.localName] = element.value;
      }
    });

    return namespaces;
  }

  static EpubGuide readGuide(XmlElement guideNode) {
    final guideReferences = <EpubGuideReference>[];

    guideNode.children.whereType<XmlElement>().forEach((guideReferenceNode) {
      if (guideReferenceNode.name.local.toLowerCase() == 'reference') {
        final guideReference = EpubGuideReference();

        guideReferenceNode.attributes.forEach((guideReferenceNodeAttribute) {
          final attributeValue = valueOrInnerText(guideReferenceNodeAttribute);

          switch (guideReferenceNodeAttribute.name.local.toLowerCase()) {
            case 'type':
              guideReference.type = attributeValue;
              break;
            case 'title':
              guideReference.title = attributeValue;
              break;
            case 'href':
              guideReference.href = attributeValue;
              break;
          }
        });

        if (guideReference.type == null || guideReference.type!.isEmpty) {
          throw Exception('Incorrect EPUB guide: item type is missing');
        }

        if (guideReference.href == null || guideReference.href!.isEmpty) {
          throw Exception('Incorrect EPUB guide: item href is missing');
        }

        guideReferences.add(guideReference);
      }
    });

    return EpubGuide(items: guideReferences);
  }

  static EpubManifest readManifest(XmlElement manifestNode) {
    final manifestItems = <EpubManifestItem>[];

    manifestNode.children.whereType<XmlElement>().forEach((manifestItemNode) {
      if (manifestItemNode.name.local.toLowerCase() == 'item') {
        final manifestItem = EpubManifestItem();

        manifestItemNode.attributes.forEach((manifestItemNodeAttribute) {
          final attributeValue = valueOrInnerText(manifestItemNodeAttribute);

          switch (manifestItemNodeAttribute.name.local.toLowerCase()) {
            case 'id':
              manifestItem.id = attributeValue;
              break;
            case 'href':
              manifestItem.href = attributeValue;
              break;
            case 'media-type':
              manifestItem.mediaType = attributeValue;
              break;
            case 'media-overlay':
              manifestItem.mediaOverlay = attributeValue;
              break;
            case 'required-namespace':
              manifestItem.requiredNamespace = attributeValue;
              break;
            case 'required-modules':
              manifestItem.requiredModules = attributeValue;
              break;
            case 'fallback':
              manifestItem.fallback = attributeValue;
              break;
            case 'fallback-style':
              manifestItem.fallbackStyle = attributeValue;
              break;
            case 'properties':
              manifestItem.properties = attributeValue;
              break;
          }
        });

        if (manifestItem.id == null || manifestItem.id!.isEmpty) {
          throw Exception('Incorrect EPUB manifest: item ID is missing');
        }

        if (manifestItem.href == null || manifestItem.href!.isEmpty) {
          throw Exception('Incorrect EPUB manifest: item href is missing');
        }

        if (manifestItem.mediaType == null || manifestItem.mediaType!.isEmpty) {
          throw Exception(
            'Incorrect EPUB manifest: item media type is missing',
          );
        }

        manifestItems.add(manifestItem);
      }
    });

    return EpubManifest(items: manifestItems);
  }

  static EpubMetadata readMetadata(
    XmlElement metadataNode,
    EpubVersion? epubVersion,
  ) {
    final result = EpubMetadata(
      metaItems: metadataNode.children
          .whereType<XmlElement>()
          .where((metadataItemNode) =>
              metadataItemNode.name.local.toLowerCase() == 'meta')
          .map((metadataMetaNode) => readMetadataMeta(metadataMetaNode))
          .toList(),
    );

    metadataNode.children.whereType<XmlElement>().forEach((metadataItemNode) {
      switch (metadataItemNode.name.local.toLowerCase()) {
        case 'title':
          result.titles.add(readMetadataTranslatedString(metadataItemNode));
          break;
        case 'creator':
        case 'contributor':
          final tagName = metadataItemNode.name.local.toLowerCase();
          final contributor = readMetadataContributor(metadataItemNode);

          if (epubVersion == EpubVersion.epub3) {
            final associatedMetaItems = result.metaItems.where((meta) {
              meta.refines = meta.refines?.trim();

              if (contributor.id != null &&
                  (meta.refines == '#${contributor.id}')) {
                return true;
              }

              return false;
            });

            contributor
              ..role = associatedMetaItems
                  .firstWhereOrNull((meta) => (meta.property == 'role'))
                  ?.textContent
              ..fileAs = associatedMetaItems
                  .firstWhereOrNull((meta) => (meta.property == 'file-as'))
                  ?.textContent
              ..alternateScripts = associatedMetaItems
                  .where((meta) => meta.property == 'alternate-script')
                  .map((meta) => EpubMetadataAlternateScript(
                        value: meta.textContent, // Name in another language.
                        lang: meta.attributes?['lang'],
                        dir: meta.attributes?['dir'],
                      ))
                  .toList()
              ..displaySeq = int.tryParse(
                associatedMetaItems
                        .firstWhereOrNull(
                          (meta) => meta.property == 'display-seq',
                        )
                        ?.textContent ??
                    '',
              );
          }

          if (tagName == 'creator') {
            result.creators.add(contributor);
          } else {
            result.contributors.add(contributor);
          }

          break;
        case 'subject':
          result.subjects.add(readMetadataTranslatedString(metadataItemNode));
          break;
        case 'description':
          result.descriptions.add(
            readMetadataTranslatedString(metadataItemNode),
          );
          break;
        case 'publisher':
          result.publishers.add(
            readMetadataTranslatedString(metadataItemNode),
          );
          break;
        case 'date':
          result.dates.add(readMetadataDate(metadataItemNode));
          break;
        case 'type':
          result.types.add(readMetadataString(metadataItemNode));
          break;
        case 'format':
          result.formats.add(readMetadataString(metadataItemNode));
          break;
        case 'identifier':
          result.identifiers.add(readMetadataIdentifier(metadataItemNode));
          break;
        case 'source':
          result.sources.add(readMetadataString(metadataItemNode));
          break;
        case 'language':
          result.languages.add(readMetadataString(metadataItemNode));
          break;
        case 'relation':
          result.relations.add(readMetadataTranslatedString(metadataItemNode));
          break;
        case 'coverage':
          result.coverages.add(readMetadataTranslatedString(metadataItemNode));
          break;
        case 'rights':
          result.rights.add(readMetadataTranslatedString(metadataItemNode));
          break;
      }
    });

    return result;
  }

  static EpubMetadataContributor readMetadataContributor(
    XmlElement metadataContributorNode,
  ) {
    final result = EpubMetadataContributor();

    metadataContributorNode.attributes
        .forEach((metadataContributorNodeAttribute) {
      final attributeValue = valueOrInnerText(metadataContributorNodeAttribute);

      switch (metadataContributorNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result.id = attributeValue;
          break;
        case 'dir':
          result.dir = attributeValue;
          break;
        case 'lang':
          result.lang = attributeValue;
          break;
        case 'role':
          result.role = attributeValue;
          break;
        case 'file-as':
          result.fileAs = attributeValue;
          break;
      }
    });

    result.name = valueOrInnerText(metadataContributorNode);
    return result;
  }

  static EpubMetadataDate readMetadataDate(XmlElement metadataDateNode) {
    final eventAttribute = metadataDateNode.getAttribute(
      'event',
      namespace: Namespaces.opf,
    );
    final result = EpubMetadataDate();

    if (eventAttribute != null && eventAttribute.isNotEmpty) {
      result.event = eventAttribute;
    }

    result.date = valueOrInnerText(metadataDateNode);
    return result;
  }

  static EpubMetadataIdentifier readMetadataIdentifier(
    XmlElement metadataIdentifierNode,
  ) {
    final result = EpubMetadataIdentifier();

    metadataIdentifierNode.attributes.forEach(
      (metadataIdentifierNodeAttribute) {
        final attributeValue =
            valueOrInnerText(metadataIdentifierNodeAttribute);

        switch (metadataIdentifierNodeAttribute.name.local.toLowerCase()) {
          case 'id':
            result.id = attributeValue;
            break;
          case 'scheme':
            result.scheme = attributeValue;
            break;
        }
      },
    );

    result.identifier = valueOrInnerText(metadataIdentifierNode);
    return result;
  }

  /// [readMetadata MetaVersion2] and [readMetadata MetaVersion3] have been merged for backward compatibility.
  static EpubMetadataMeta readMetadataMeta(XmlElement metadataMetaNode) {
    final result = EpubMetadataMeta(
      attributes: {},
    );

    metadataMetaNode.attributes.forEach(
      (metadataMetaNodeAttribute) {
        final attributeName =
            metadataMetaNodeAttribute.name.local.toLowerCase();
        final attributeValue = valueOrInnerText(metadataMetaNodeAttribute);

        result.attributes![attributeName] = attributeValue;

        switch (attributeName) {
          case 'id':
            result.id = attributeValue;
            break;
          case 'name':
            result.name = attributeValue;
            break;
          case 'content':
            result.content = attributeValue;
            break;
          case 'refines':
            result.refines = attributeValue;
            break;
          case 'property':
            result.property = attributeValue;
            break;
          case 'scheme':
            result.scheme = attributeValue;
            break;
          case 'lang':
          case 'xml:lang':
            result.lang = attributeValue;
            break;
          case 'dir':
            result.dir = attributeValue;
            break;
        }
      },
    );

    result.textContent = valueOrInnerText(metadataMetaNode);
    return result;
  }

  static EpubMetadataString readMetadataString(XmlElement metadataItemNode) =>
      EpubMetadataString(
        id: metadataItemNode.getAttribute('id'),
        value: valueOrInnerText(metadataItemNode),
        attributes: _readAttributes(
          metadataItemNode.attributes,
          exclude: ['id'],
        ),
      );

  static EpubMetadataTranslatedString readMetadataTranslatedString(
    XmlElement metadataItemNode,
  ) =>
      EpubMetadataTranslatedString(
        id: metadataItemNode.getAttribute('id'),
        value: valueOrInnerText(metadataItemNode),
        lang: metadataItemNode.getAttribute('lang'),
        dir: metadataItemNode.getAttribute('dir'),
        attributes: _readAttributes(
          metadataItemNode.attributes,
          exclude: ["id", "lang", "dir"],
        ),
      );

  static Future<EpubPackage> readPackage(
    Archive epubArchive,
    String rootFilePath,
  ) async {
    final rootFileEntry = epubArchive.files.firstWhereOrNull(
      (file) => file.name == rootFilePath,
    );

    if (rootFileEntry == null) {
      throw Exception('EPUB parsing error: root file not found in archive.');
    }

    final packageNode = XmlDocument.parse(utf8.decode(rootFileEntry.content))
        .findElements('package', namespace: Namespaces.opf)
        .first;
    final epubVersionValue = packageNode.getAttribute('version');
    final result = EpubPackage(
      namespaces: _readNamespaces(packageNode.attributes),
      uniqueIdentifier: packageNode.getAttribute('unique-identifier'),
      lang: packageNode.getAttribute('lang'),
      dir: packageNode.getAttribute('dir'),
    );

    if (epubVersionValue == '2.0') {
      result.version = EpubVersion.epub2;
    } else if (epubVersionValue == '3.0') {
      result.version = EpubVersion.epub3;
    } else {
      throw Exception('Unsupported EPUB version: $epubVersionValue.');
    }

    final metadataNode = packageNode
        .findElements('metadata', namespace: Namespaces.opf)
        .cast<XmlElement?>()
        .firstWhere((elem) => elem != null);

    if (metadataNode == null) {
      throw Exception('EPUB parsing error: metadata not found in the package.');
    }

    final manifestNode = packageNode
        .findElements('manifest', namespace: Namespaces.opf)
        .cast<XmlElement?>()
        .firstWhere((elem) => elem != null);

    if (manifestNode == null) {
      throw Exception('EPUB parsing error: manifest not found in the package.');
    }

    final spineNode = packageNode
        .findElements('spine', namespace: Namespaces.opf)
        .cast<XmlElement?>()
        .firstWhere((elem) => elem != null);

    if (spineNode == null) {
      throw Exception('EPUB parsing error: spine not found in the package.');
    }

    final guideNode = packageNode
        .findElements('guide', namespace: Namespaces.opf)
        .firstOrNull;

    result
      ..metadata = readMetadata(metadataNode, result.version)
      ..manifest = readManifest(manifestNode)
      ..spine = readSpine(spineNode);

    if (guideNode != null) {
      result.guide = readGuide(guideNode);
    }

    return result;
  }

  static EpubSpine readSpine(XmlElement spineNode) {
    final tocAttribute = spineNode.getAttribute('toc');
    final pageProgression = spineNode.getAttribute(
      'page-progression-direction',
    );
    final result = EpubSpine(
      tableOfContents: tocAttribute,
      ltr: pageProgression == null || pageProgression.toLowerCase() == 'ltr',
    );

    spineNode.children.whereType<XmlElement>().forEach((spineItemNode) {
      if (spineItemNode.name.local.toLowerCase() == 'itemref') {
        final idRefAttribute = spineItemNode.getAttribute('idref');

        if (idRefAttribute == null || idRefAttribute.isEmpty) {
          throw Exception('Incorrect EPUB spine: item ID ref is missing');
        }

        final linearAttribute = spineItemNode.getAttribute('linear');

        result.items.add(EpubSpineItemRef(
          idRef: idRefAttribute,
          isLinear:
              linearAttribute == null || linearAttribute.toLowerCase() == 'yes',
        ));
      }
    });

    return result;
  }
}
