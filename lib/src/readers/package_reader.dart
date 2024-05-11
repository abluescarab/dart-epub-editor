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
import '../schema/opf/epub_metadata_creator_alternate_script.dart';
import '../schema/opf/epub_metadata_date.dart';
import '../schema/opf/epub_metadata_identifier.dart';
import '../schema/opf/epub_metadata_meta.dart';
import '../schema/opf/epub_package.dart';
import '../schema/opf/epub_spine.dart';
import '../schema/opf/epub_spine_item_ref.dart';
import '../schema/opf/epub_version.dart';

class PackageReader {
  static EpubMetadataTranslatedString _createMetadataString(
    XmlElement metadataItemNode,
    String text,
  ) {
    return EpubMetadataTranslatedString(
      id: metadataItemNode.getAttribute('id'),
      value: text,
      lang: metadataItemNode.getAttribute('lang'),
      dir: metadataItemNode.getAttribute('dir'),
    );
  }

  static EpubGuide readGuide(XmlElement guideNode) {
    var result = EpubGuide();
    result.items = <EpubGuideReference>[];
    guideNode.children
        .whereType<XmlElement>()
        .forEach((XmlElement guideReferenceNode) {
      if (guideReferenceNode.name.local.toLowerCase() == 'reference') {
        var guideReference = EpubGuideReference();
        guideReferenceNode.attributes
            .forEach((XmlAttribute guideReferenceNodeAttribute) {
          var attributeValue = valueOrInnerText(guideReferenceNodeAttribute);
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
    var result = EpubManifest();
    result.items = <EpubManifestItem>[];
    manifestNode.children
        .whereType<XmlElement>()
        .forEach((XmlElement manifestItemNode) {
      if (manifestItemNode.name.local.toLowerCase() == 'item') {
        var manifestItem = EpubManifestItem();
        manifestItemNode.attributes
            .forEach((XmlAttribute manifestItemNodeAttribute) {
          var attributeValue = valueOrInnerText(manifestItemNodeAttribute);
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
      XmlElement metadataNode, EpubVersion? epubVersion) {
    var result = EpubMetadata();
    result.titles = <EpubMetadataTranslatedString>[];
    result.descriptions = <EpubMetadataTranslatedString>[];
    result.creators = <EpubMetadataContributor>[];
    result.subjects = <EpubMetadataTranslatedString>[];
    result.publishers = <EpubMetadataTranslatedString>[];
    result.contributors = <EpubMetadataContributor>[];
    result.dates = <EpubMetadataDate>[];
    result.types = <EpubMetadataString>[];
    result.formats = <EpubMetadataString>[];
    result.identifiers = <EpubMetadataIdentifier>[];
    result.sources = <EpubMetadataString>[];
    result.languages = <EpubMetadataString>[];
    result.relations = <EpubMetadataTranslatedString>[];
    result.coverages = <EpubMetadataTranslatedString>[];
    result.rights = <EpubMetadataTranslatedString>[];

    result.metaItems = metadataNode.children.whereType<XmlElement>().where(
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
      var innerText = valueOrInnerText(metadataItemNode);
      switch (metadataItemNode.name.local.toLowerCase()) {
        case 'title':
          result.titles!.add(
            _createMetadataString(metadataItemNode, innerText),
          );
          break;
        case 'creator':
        case 'contributor':
          final tagName = metadataItemNode.name.local.toLowerCase();
          var creatorOrContributor;

          if (tagName == 'creator') {
            creatorOrContributor = readMetadataCreator(metadataItemNode);
          } else {
            creatorOrContributor = readMetadataContributor(metadataItemNode);
          }

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
                .map(
              (EpubMetadataMeta meta) {
                return EpubMetadataCreatorAlternateScript()
                  ..name = meta.textContent // Name in another language.
                  ..lang = meta.attributes?['lang']
                  ..dir = meta.attributes?['dir'];
              },
            ).toList());

            creatorOrContributor.displaySeq = int.tryParse(associatedMetaItems
                    .firstWhereOrNull(
                      (EpubMetadataMeta meta) =>
                          (meta.property == 'display-seq'),
                    )
                    ?.textContent ??
                '');
            ;
          }

          if (tagName == 'creator') {
            result.creators!.add(creatorOrContributor);
          } else {
            result.contributors!.add(creatorOrContributor);
          }
          break;
        case 'subject':
          result.subjects!.add(
            _createMetadataString(metadataItemNode, innerText),
          );
          break;
        case 'description':
          result.descriptions!.add(
            _createMetadataString(metadataItemNode, innerText),
          );
          break;
        case 'publisher':
          result.publishers!.add(
            _createMetadataString(metadataItemNode, innerText),
          );
          break;

        case 'date':
          var date = readMetadataDate(metadataItemNode);
          result.dates!.add(date);
          break;
        case 'type':
          result.types!.add(
            EpubMetadataString(
              id: metadataItemNode.getAttribute('id'),
              value: innerText,
            ),
          );
          break;
        case 'format':
          result.formats!.add(
            EpubMetadataString(
              id: metadataItemNode.getAttribute('id'),
              value: innerText,
            ),
          );
          break;
        case 'identifier':
          var identifier = readMetadataIdentifier(metadataItemNode);
          result.identifiers!.add(identifier);
          break;
        case 'source':
          result.sources!.add(
            EpubMetadataString(
              id: metadataItemNode.getAttribute('id'),
              value: innerText,
            ),
          );
          break;
        case 'language':
          result.languages!.add(
            EpubMetadataString(
              id: metadataItemNode.getAttribute('id'),
              value: innerText,
            ),
          );
          break;
        case 'relation':
          result.relations!.add(
            _createMetadataString(metadataItemNode, innerText),
          );
          break;
        case 'coverage':
          result.coverages!.add(
            _createMetadataString(metadataItemNode, innerText),
          );
          break;
        case 'rights':
          result.rights!.add(
            _createMetadataString(metadataItemNode, innerText),
          );
          break;
        /*case 'meta':
          if (epubVersion == EpubVersion.epub2) {
            var meta = readMetadataMetaVersion2(metadataItemNode);
            result.metaItems!.add(meta);
          } else if (epubVersion == EpubVersion.epub3) {
            var meta = readMetadataMetaVersion3(metadataItemNode);
            result.metaItems!.add(meta);
          }
          break;*/
      }
    });
    return result;
  }

  static EpubMetadataContributor readMetadataContributor(
      XmlElement metadataContributorNode) {
    var result = EpubMetadataContributor();
    metadataContributorNode.attributes
        .forEach((XmlAttribute metadataContributorNodeAttribute) {
      var attributeValue = valueOrInnerText(metadataContributorNodeAttribute);
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

  static EpubMetadataContributor readMetadataCreator(
      XmlElement metadataCreatorNode) {
    var result = EpubMetadataContributor();
    metadataCreatorNode.attributes
        .forEach((XmlAttribute metadataCreatorNodeAttribute) {
      var attributeValue = valueOrInnerText(metadataCreatorNodeAttribute);
      switch (metadataCreatorNodeAttribute.name.local.toLowerCase()) {
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

    result.name = valueOrInnerText(metadataCreatorNode);

    return result;
  }

  static EpubMetadataDate readMetadataDate(XmlElement metadataDateNode) {
    var result = EpubMetadataDate();
    var eventAttribute = metadataDateNode.getAttribute('event',
        namespace: metadataDateNode.name.namespaceUri);
    if (eventAttribute != null && eventAttribute.isNotEmpty) {
      result.event = eventAttribute;
    }
    result.date = valueOrInnerText(metadataDateNode);
    return result;
  }

  static EpubMetadataIdentifier readMetadataIdentifier(
      XmlElement metadataIdentifierNode) {
    var result = EpubMetadataIdentifier();
    metadataIdentifierNode.attributes
        .forEach((XmlAttribute metadataIdentifierNodeAttribute) {
      var attributeValue = valueOrInnerText(metadataIdentifierNodeAttribute);
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
    var result = EpubMetadataMeta();
    metadataMetaNode.attributes.forEach((XmlAttribute metadataMetaNodeAttribute) {
      var attributeValue = metadataMetaNodeAttribute.text;
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
    var result = EpubMetadataMeta();

    result.attributes = {};

    metadataMetaNode.attributes
        .forEach((XmlAttribute metadataMetaNodeAttribute) {
      var attributeName = metadataMetaNodeAttribute.name.local.toLowerCase();
      var attributeValue = valueOrInnerText(metadataMetaNodeAttribute);

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

  static Future<EpubPackage> readPackage(
      Archive epubArchive, String rootFilePath) async {
    var rootFileEntry = epubArchive.files.firstWhereOrNull(
        (ArchiveFile testFile) => testFile.name == rootFilePath);
    if (rootFileEntry == null) {
      throw Exception('EPUB parsing error: root file not found in archive.');
    }
    var containerDocument =
        XmlDocument.parse(convert.utf8.decode(rootFileEntry.content));
    var opfNamespace = 'http://www.idpf.org/2007/opf';
    var packageNode = containerDocument
        .findElements('package', namespace: opfNamespace)
        .firstWhere((XmlElement? elem) => elem != null);
    var result = EpubPackage();
    var epubVersionValue = packageNode.getAttribute('version');
    if (epubVersionValue == '2.0') {
      result.version = EpubVersion.epub2;
    } else if (epubVersionValue == '3.0') {
      result.version = EpubVersion.epub3;
    } else {
      throw Exception('Unsupported EPUB version: $epubVersionValue.');
    }

    result.lang = packageNode.getAttribute('lang');
    result.dir = packageNode.getAttribute('dir');

    var metadataNode = packageNode
        .findElements('metadata', namespace: opfNamespace)
        .cast<XmlElement?>()
        .firstWhere((XmlElement? elem) => elem != null);
    if (metadataNode == null) {
      throw Exception('EPUB parsing error: metadata not found in the package.');
    }
    var metadata = readMetadata(metadataNode, result.version);
    result.metadata = metadata;
    var manifestNode = packageNode
        .findElements('manifest', namespace: opfNamespace)
        .cast<XmlElement?>()
        .firstWhere((XmlElement? elem) => elem != null);
    if (manifestNode == null) {
      throw Exception('EPUB parsing error: manifest not found in the package.');
    }
    var manifest = readManifest(manifestNode);
    result.manifest = manifest;

    var spineNode = packageNode
        .findElements('spine', namespace: opfNamespace)
        .cast<XmlElement?>()
        .firstWhere((XmlElement? elem) => elem != null);
    if (spineNode == null) {
      throw Exception('EPUB parsing error: spine not found in the package.');
    }
    var spine = readSpine(spineNode);
    result.spine = spine;
    var guideNode = packageNode
        .findElements('guide', namespace: opfNamespace)
        .firstWhereOrNull((XmlElement? elem) => elem != null);
    if (guideNode != null) {
      var guide = readGuide(guideNode);
      result.guide = guide;
    }
    return result;
  }

  static EpubSpine readSpine(XmlElement spineNode) {
    var result = EpubSpine();
    result.items = <EpubSpineItemRef>[];
    var tocAttribute = spineNode.getAttribute('toc');
    result.tableOfContents = tocAttribute;
    var pageProgression = spineNode.getAttribute('page-progression-direction');
    result.ltr =
        ((pageProgression == null) || pageProgression.toLowerCase() == 'ltr');
    spineNode.children
        .whereType<XmlElement>()
        .forEach((XmlElement spineItemNode) {
      if (spineItemNode.name.local.toLowerCase() == 'itemref') {
        var spineItemRef = EpubSpineItemRef();
        var idRefAttribute = spineItemNode.getAttribute('idref');
        if (idRefAttribute == null || idRefAttribute.isEmpty) {
          throw Exception('Incorrect EPUB spine: item ID ref is missing');
        }
        spineItemRef.idRef = idRefAttribute;
        var linearAttribute = spineItemNode.getAttribute('linear');
        spineItemRef.isLinear =
            linearAttribute == null || (linearAttribute.toLowerCase() == 'no');
        result.items!.add(spineItemRef);
      }
    });
    return result;
  }
}
