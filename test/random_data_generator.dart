import 'dart:math' show Random;
import 'package:epub_editor/src/schema/navigation/epub_navigation_content.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_doc_author.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_doc_title.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_head.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_head_meta.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_label.dart';

import 'package:epub_editor/src/schema/navigation/epub_navigation_point.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_target.dart';
import 'package:epub_editor/src/schema/opf/epub_guide.dart';
import 'package:epub_editor/src/schema/opf/epub_guide_reference.dart';
import 'package:epub_editor/src/schema/opf/epub_manifest.dart';
import 'package:epub_editor/src/schema/opf/epub_manifest_item.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata.dart';
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

class RandomString {
  RandomString(this.rng);

  final Random rng;

  static const asciiStart = 33;
  static const asciiEnd = 126;
  static const numericStart = 48;
  static const numericEnd = 57;
  static const lowerAlphaStart = 97;
  static const lowerAlphaEnd = 122;
  static const upperAlphaStart = 65;
  static const upperAlphaEnd = 90;

  /// Generates a random integer where [from] <= [to].
  int randomBetween(int from, int to) {
    if (from > to) {
      throw Exception('$from is not > $to');
    }

    return ((to - from) * rng.nextDouble()).toInt() + from;
  }

  /// Generates a random string of [length] with characters
  /// between ascii [from] to [to].
  /// Defaults to characters of ascii '!' to '~'.
  String randomString(
    int length, {
    int from = asciiStart,
    int to = asciiEnd,
  }) =>
      String.fromCharCodes(
        List.generate(length, (index) => randomBetween(from, to)),
      );

  /// Generates a random string of [length] with only numeric characters.
  String randomNumeric(int length) => randomString(
        length,
        from: numericStart,
        to: numericEnd,
      );

  /// Generates a random string of [length] with only alpha characters.
  String randomAlpha(int length) {
    final lowerAlphaLength = randomBetween(0, length);

    return randomMerge(
      randomString(
        lowerAlphaLength,
        from: lowerAlphaStart,
        to: lowerAlphaEnd,
      ),
      randomString(
        length - lowerAlphaLength,
        from: upperAlphaStart,
        to: upperAlphaEnd,
      ),
    );
  }

  /// Generates a random string of [length] with alpha-numeric characters.
  String randomAlphaNumeric(int length) {
    final alphaLength = randomBetween(0, length);
    return randomMerge(
      randomAlpha(alphaLength),
      randomNumeric(length - alphaLength),
    );
  }

  /// Merge [a] with [b] and scramble characters.
  String randomMerge(String a, String b) {
    List<int> mergedCodeUnits = List.from("$a$b".codeUnits);
    mergedCodeUnits.shuffle(rng);
    return String.fromCharCodes(mergedCodeUnits);
  }
}

class RandomDataGenerator {
  final Random rng;
  late RandomString _randomString;
  final int _length;

  RandomDataGenerator(this.rng, this._length) {
    _randomString = RandomString(rng);
  }

  String randomString() => _randomString.randomAlphaNumeric(_length);

  EpubNavigationPoint randomEpubNavigationPoint([int depth = 0]) =>
      EpubNavigationPoint(
        playOrder: randomString(),
        navigationLabels: [randomEpubNavigationLabel()],
        id: randomString(),
        content: randomEpubNavigationContent(),
        classAttribute: randomString(),
        childNavigationPoints: depth > 0
            ? [randomEpubNavigationPoint(depth - 1)]
            : <EpubNavigationPoint>[],
      );

  EpubNavigationContent randomEpubNavigationContent() => EpubNavigationContent(
        id: randomString(),
        source: randomString(),
      );

  EpubNavigationTarget randomEpubNavigationTarget() => EpubNavigationTarget(
        classAttribute: randomString(),
        content: randomEpubNavigationContent(),
        id: randomString(),
        navigationLabels: [randomEpubNavigationLabel()],
        playOrder: randomString(),
        value: randomString(),
      );

  EpubNavigationLabel randomEpubNavigationLabel() => EpubNavigationLabel(
        text: randomString(),
      );

  EpubNavigationHead randomEpubNavigationHead() => EpubNavigationHead(
        metadata: [randomNavigationHeadMeta()],
      );

  EpubNavigationHeadMeta randomNavigationHeadMeta() => EpubNavigationHeadMeta(
        content: randomString(),
        name: randomString(),
        scheme: randomString(),
      );

  EpubNavigationDocTitle randomNavigationDocTitle() => EpubNavigationDocTitle(
        titles: [randomString()],
      );

  EpubNavigationDocAuthor randomNavigationDocAuthor() =>
      EpubNavigationDocAuthor(
        authors: [randomString()],
      );

  EpubPackage randomEpubPackage() => EpubPackage(
        guide: randomEpubGuide(),
        manifest: randomEpubManifest(),
        metadata: randomEpubMetadata(),
        spine: randomEpubSpine(),
        version: rng.nextBool() ? EpubVersion.epub2 : EpubVersion.epub3,
      );

  EpubSpine randomEpubSpine() => EpubSpine(
        items: [randomEpubSpineItemRef()],
        tableOfContents: _randomString.randomAlpha(_length),
      );

  EpubSpineItemRef randomEpubSpineItemRef() => EpubSpineItemRef(
        idRef: _randomString.randomAlpha(_length),
      );

  EpubManifest randomEpubManifest() => EpubManifest(
        items: [randomEpubManifestItem()],
      );

  EpubManifestItem randomEpubManifestItem() => EpubManifestItem(
        fallback: _randomString.randomAlpha(_length),
        fallbackStyle: _randomString.randomAlpha(_length),
        href: _randomString.randomAlpha(_length),
        id: _randomString.randomAlpha(_length),
        mediaType: _randomString.randomAlpha(_length),
        requiredModules: _randomString.randomAlpha(_length),
        requiredNamespace: _randomString.randomAlpha(_length),
      );

  EpubGuide randomEpubGuide() => EpubGuide(
        items: [randomEpubGuideReference()],
      );

  EpubGuideReference randomEpubGuideReference() => EpubGuideReference(
        href: _randomString.randomAlpha(_length),
        title: _randomString.randomAlpha(_length),
        type: _randomString.randomAlpha(_length),
      );

  EpubMetadata randomEpubMetadata() => EpubMetadata(
        contributors: [randomEpubMetadataContributor()],
        coverages: [randomEpubMetadataTranslatedString()],
        creators: [randomEpubMetadataContributor()],
        dates: [randomEpubMetadataDate()],
        descriptions: [randomEpubMetadataTranslatedString()],
        formats: [randomEpubMetadataString()],
        identifiers: [randomEpubMetadataIdentifier()],
        languages: [randomEpubMetadataString()],
        metaItems: [randomEpubMetadataMeta()],
        publishers: [randomEpubMetadataTranslatedString()],
        relations: [randomEpubMetadataTranslatedString()],
        rights: [randomEpubMetadataTranslatedString()],
        sources: [randomEpubMetadataString()],
        subjects: [randomEpubMetadataTranslatedString()],
        titles: [randomEpubMetadataTranslatedString()],
        types: [randomEpubMetadataString()],
      );

  EpubMetadataMeta randomEpubMetadataMeta() => EpubMetadataMeta(
        content: _randomString.randomAlpha(_length),
        id: _randomString.randomAlpha(_length),
        name: _randomString.randomAlpha(_length),
        property: _randomString.randomAlpha(_length),
        refines: _randomString.randomAlpha(_length),
        scheme: _randomString.randomAlpha(_length),
      );

  EpubMetadataIdentifier randomEpubMetadataIdentifier() =>
      EpubMetadataIdentifier(
        id: _randomString.randomAlpha(_length),
        identifier: _randomString.randomAlpha(_length),
        scheme: _randomString.randomAlpha(_length),
      );

  EpubMetadataDate randomEpubMetadataDate() => EpubMetadataDate(
        date: _randomString.randomAlpha(_length),
        event: _randomString.randomAlpha(_length),
      );

  EpubMetadataContributor randomEpubMetadataContributor() =>
      EpubMetadataContributor(
        name: _randomString.randomAlpha(_length),
        fileAs: _randomString.randomAlpha(_length),
        role: _randomString.randomAlpha(_length),
      );

  EpubMetadataString randomEpubMetadataString() => EpubMetadataString(
        value: _randomString.randomAlpha(_length),
      );

  EpubMetadataTranslatedString randomEpubMetadataTranslatedString() =>
      EpubMetadataTranslatedString(
        value: _randomString.randomAlpha(_length),
        dir: "ltr",
        lang: "en",
      );
}
