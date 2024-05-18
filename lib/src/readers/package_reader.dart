import 'dart:async';

import 'package:archive/archive.dart';
import 'dart:convert' as convert;
import 'package:collection/collection.dart' show IterableExtension;
import 'package:epub_editor/src/schema/opf/epub_metadata_string.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_translated_string.dart';
import 'package:epub_editor/src/utils/value_or_inner_text.dart';
import 'package:xml/xml.dart';

import '../schema/opf/epub_guide.dart';
import '../schema/opf/epub_guide_reference.dart';
import '../schema/opf/epub_manifest.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_metadata.dart';
import '../schema/opf/epub_metadata_contributor.dart';
import '../schema/opf/epub_metadata_alternate_script.dart';
import '../schema/opf/epub_metadata_date.dart';
import '../schema/opf/epub_metadata_identifier.dart';
import '../schema/opf/epub_metadata_meta.dart';
import '../schema/opf/epub_package.dart';
import '../schema/opf/epub_spine.dart';
import '../schema/opf/epub_spine_item_ref.dart';
import '../schema/opf/epub_version.dart';

class PackageReader {
  static EpubGuide readGuide(XmlElement guideNode) {
    final result = EpubGuide();
    result.items = <EpubGuideReference>[];

    guideNode.children
        .whereType<XmlElement>()
        .forEach((XmlElement guideReferenceNode) {
      if (guideReferenceNode.name.local.toLowerCase() == 'reference') {
        final guideReference = EpubGuideReference();

        guideReferenceNode.attributes
            .forEach((XmlAttribute guideReferenceNodeAttribute) {
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

        result.items!.add(guideReference);
      }
    });

    return result;
  }

  static EpubManifest readManifest(XmlElement manifestNode) {
    final result = EpubManifest();
    result.items = <EpubManifestItem>[];

    manifestNode.children
        .whereType<XmlElement>()
        .forEach((XmlElement manifestItemNode) {
      if (manifestItemNode.name.local.toLowerCase() == 'item') {
        final manifestItem = EpubManifestItem();

        manifestItemNode.attributes
            .forEach((XmlAttribute manifestItemNodeAttribute) {
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
              'Incorrect EPUB manifest: item media type is missing');
        }

        result.items!.add(manifestItem);
      }
    });

    return result;
  }

  static EpubMetadata readMetadata(
    XmlElement metadataNode,
    EpubVersion? epubVersion,
  ) {
    final result = EpubMetadata()
      ..titles = <EpubMetadataTranslatedString>[]
      ..descriptions = <EpubMetadataTranslatedString>[]
      ..creators = <EpubMetadataContributor>[]
      ..subjects = <EpubMetadataTranslatedString>[]
      ..publishers = <EpubMetadataTranslatedString>[]
      ..contributors = <EpubMetadataContributor>[]
      ..dates = <EpubMetadataDate>[]
      ..types = <EpubMetadataString>[]
      ..formats = <EpubMetadataString>[]
      ..identifiers = <EpubMetadataIdentifier>[]
      ..sources = <EpubMetadataString>[]
      ..languages = <EpubMetadataString>[]
      ..relations = <EpubMetadataTranslatedString>[]
      ..coverages = <EpubMetadataTranslatedString>[]
      ..rights = <EpubMetadataTranslatedString>[]
      ..metaItems = metadataNode.children.whereType<XmlElement>().where(
        (XmlElement metadataItemNode) {
          return (metadataItemNode.name.local.toLowerCase() == 'meta');
        },
      ).map(
        (XmlElement metadataMetaNode) {
          return readMetadataMeta(metadataMetaNode);

          /*switch (epubVersion) {
          case EpubVersion.epub3:
            return readMetadataMeta(metadataMetaNode);

          case EpubVersion.epub2:
          default:
            return readMetadataMetaVersion2(metadataMetaNode);
        }*/
        },
      ).toList();

    metadataNode.children
        .whereType<XmlElement>()
        .forEach((XmlElement metadataItemNode) {
      switch (metadataItemNode.name.local.toLowerCase()) {
        case 'title':
          result.titles!.add(
            readMetadataTranslatedString(metadataItemNode),
          );
          break;
        case 'creator':
        case 'contributor':
          final tagName = metadataItemNode.name.local.toLowerCase();
          final creatorOrContributor =
              readMetadataContributor(metadataItemNode);

          if (epubVersion == EpubVersion.epub3) {
            final associatedMetaItems = result.metaItems!.where(
              (EpubMetadataMeta meta) {
                meta.refines = meta.refines?.trim();

                if (creatorOrContributor.id != null &&
                    (meta.refines == '#${creatorOrContributor.id}')) {
                  return true;
                }

                return false;
              },
            );

            creatorOrContributor.role = associatedMetaItems
                .firstWhereOrNull(
                  (EpubMetadataMeta meta) => (meta.property == 'role'),
                )
                ?.textContent;

            creatorOrContributor.fileAs = associatedMetaItems
                .firstWhereOrNull(
                  (EpubMetadataMeta meta) => (meta.property == 'file-as'),
                )
                ?.textContent;

            creatorOrContributor.alternateScripts = (associatedMetaItems
                .where(
              (EpubMetadataMeta meta) => (meta.property == 'alternate-script'),
            )
                .map((EpubMetadataMeta meta) {
              return EpubMetadataAlternateScript()
                ..value = meta.textContent // Name in another language.
                ..lang = meta.attributes?['lang']
                ..dir = meta.attributes?['dir'];
            }).toList());

            creatorOrContributor.displaySeq = int.tryParse(
              associatedMetaItems
                      .firstWhereOrNull(
                        (EpubMetadataMeta meta) =>
                            (meta.property == 'display-seq'),
                      )
                      ?.textContent ??
                  '',
            );
          }

          if (tagName == 'creator') {
            result.creators!.add(creatorOrContributor);
          } else {
            result.contributors!.add(creatorOrContributor);
          }
          break;
        case 'subject':
          result.subjects!.add(
            readMetadataTranslatedString(metadataItemNode),
          );
          break;
        case 'description':
          result.descriptions!.add(
            readMetadataTranslatedString(metadataItemNode),
          );
          break;
        case 'publisher':
          result.publishers!.add(
            readMetadataTranslatedString(metadataItemNode),
          );
          break;
        case 'date':
          final date = readMetadataDate(metadataItemNode);
          result.dates!.add(date);
          break;
        case 'type':
          result.types!.add(
            readMetadataString(metadataItemNode),
          );
          break;
        case 'format':
          result.formats!.add(
            readMetadataString(metadataItemNode),
          );
          break;
        case 'identifier':
          final identifier = readMetadataIdentifier(metadataItemNode);
          result.identifiers!.add(identifier);
          break;
        case 'source':
          result.sources!.add(
            readMetadataString(metadataItemNode),
          );
          break;
        case 'language':
          result.languages!.add(
            readMetadataString(metadataItemNode),
          );
          break;
        case 'relation':
          result.relations!.add(
            readMetadataTranslatedString(metadataItemNode),
          );
          break;
        case 'coverage':
          result.coverages!.add(
            readMetadataTranslatedString(metadataItemNode),
          );
          break;
        case 'rights':
          result.rights!.add(
            readMetadataTranslatedString(metadataItemNode),
          );
          break;
        /*case 'meta':
          if (epubVersion == EpubVersion.epub2) {
            final meta = readMetadataMetaVersion2(metadataItemNode);
            result.metaItems!.add(meta);
          } else if (epubVersion == EpubVersion.epub3) {
            final meta = readMetadataMetaVersion3(metadataItemNode);
            result.metaItems!.add(meta);
          }
          break;*/
      }
    });

    return result;
  }

  static EpubMetadataContributor readMetadataContributor(
    XmlElement metadataContributorNode,
  ) {
    final result = EpubMetadataContributor();

    metadataContributorNode.attributes
        .forEach((XmlAttribute metadataContributorNodeAttribute) {
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
    final result = EpubMetadataDate();

    final eventAttribute = metadataDateNode.getAttribute('event',
        namespace: metadataDateNode.name.namespaceUri);
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

    metadataIdentifierNode.attributes
        .forEach((XmlAttribute metadataIdentifierNodeAttribute) {
      final attributeValue = valueOrInnerText(metadataIdentifierNodeAttribute);
      switch (metadataIdentifierNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result.id = attributeValue;
          break;
        case 'scheme':
          result.scheme = attributeValue;
          break;
      }
    });

    result.identifier = valueOrInnerText(metadataIdentifierNode);
    return result;
  }

  /*static EpubMetadataMeta readMetadataMetaVersion2(XmlElement metadataMetaNode) {
    final result = EpubMetadataMeta();
    metadataMetaNode.attributes.forEach((XmlAttribute metadataMetaNodeAttribute) {
      final attributeValue = metadataMetaNodeAttribute.text;
      switch (metadataMetaNodeAttribute.name.local.toLowerCase()) {
        case 'name':
          result.name = attributeValue;
          break;
        case 'content':
          result.content = attributeValue;
          break;
      }
    });
    return result;
  }*/

  /// [readMetadata MetaVersion2] and [readMetadata MetaVersion3] have been merged for backward compatibility.
  static EpubMetadataMeta readMetadataMeta(XmlElement metadataMetaNode) {
    final result = EpubMetadataMeta();

    result.attributes = {};

    metadataMetaNode.attributes
        .forEach((XmlAttribute metadataMetaNodeAttribute) {
      final attributeName = metadataMetaNodeAttribute.name.local.toLowerCase();
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
    });

    result.textContent = valueOrInnerText(metadataMetaNode);

    return result;
  }

  static EpubMetadataString readMetadataString(
    XmlElement metadataItemNode,
  ) {
    final text = valueOrInnerText(metadataItemNode);

    return EpubMetadataString(
      id: metadataItemNode.getAttribute('id'),
      value: text,
    );
  }

  static EpubMetadataTranslatedString readMetadataTranslatedString(
    XmlElement metadataItemNode,
  ) {
    final text = valueOrInnerText(metadataItemNode);

    return EpubMetadataTranslatedString(
      id: metadataItemNode.getAttribute('id'),
      value: text,
      lang: metadataItemNode.getAttribute('lang'),
      dir: metadataItemNode.getAttribute('dir'),
    );
  }

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

    final opfNamespace = 'http://www.idpf.org/2007/opf';
    final packageNode =
        XmlDocument.parse(convert.utf8.decode(rootFileEntry.content))
            .findElements('package', namespace: opfNamespace)
            .firstWhere((XmlElement? elem) => elem != null);
    final result = EpubPackage();
    final epubVersionValue = packageNode.getAttribute('version');

    if (epubVersionValue == '2.0') {
      result.version = EpubVersion.epub2;
    } else if (epubVersionValue == '3.0') {
      result.version = EpubVersion.epub3;
    } else {
      throw Exception('Unsupported EPUB version: $epubVersionValue.');
    }

    final metadataNode = packageNode
        .findElements('metadata', namespace: opfNamespace)
        .cast<XmlElement?>()
        .firstWhere((XmlElement? elem) => elem != null);

    if (metadataNode == null) {
      throw Exception('EPUB parsing error: metadata not found in the package.');
    }

    final manifestNode = packageNode
        .findElements('manifest', namespace: opfNamespace)
        .cast<XmlElement?>()
        .firstWhere((XmlElement? elem) => elem != null);

    if (manifestNode == null) {
      throw Exception('EPUB parsing error: manifest not found in the package.');
    }

    final spineNode = packageNode
        .findElements('spine', namespace: opfNamespace)
        .cast<XmlElement?>()
        .firstWhere((XmlElement? elem) => elem != null);

    if (spineNode == null) {
      throw Exception('EPUB parsing error: spine not found in the package.');
    }

    final guideNode = packageNode
        .findElements('guide', namespace: opfNamespace)
        .firstWhereOrNull((XmlElement? elem) => elem != null);

    result.uniqueIdentifier = packageNode.getAttribute('unique-identifier');
    result.lang = packageNode.getAttribute('lang');
    result.dir = packageNode.getAttribute('dir');
    result.metadata = readMetadata(metadataNode, result.version);
    result.manifest = readManifest(manifestNode);
    result.spine = readSpine(spineNode);

    if (guideNode != null) {
      result.guide = readGuide(guideNode);
    }

    return result;
  }

  static EpubSpine readSpine(XmlElement spineNode) {
    final result = EpubSpine();
    final tocAttribute = spineNode.getAttribute('toc');
    final pageProgression =
        spineNode.getAttribute('page-progression-direction');

    result.items = <EpubSpineItemRef>[];
    result.tableOfContents = tocAttribute;
    result.ltr =
        ((pageProgression == null) || pageProgression.toLowerCase() == 'ltr');

    spineNode.children
        .whereType<XmlElement>()
        .forEach((XmlElement spineItemNode) {
      if (spineItemNode.name.local.toLowerCase() == 'itemref') {
        final spineItemRef = EpubSpineItemRef();
        final idRefAttribute = spineItemNode.getAttribute('idref');

        if (idRefAttribute == null || idRefAttribute.isEmpty) {
          throw Exception('Incorrect EPUB spine: item ID ref is missing');
        }

        final linearAttribute = spineItemNode.getAttribute('linear');

        spineItemRef.idRef = idRefAttribute;
        spineItemRef.isLinear =
            linearAttribute == null || (linearAttribute.toLowerCase() == 'no');

        result.items!.add(spineItemRef);
      }
    });
    return result;
  }
}
