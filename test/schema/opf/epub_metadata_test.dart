library epubreadertest;

import 'dart:math';

import 'package:epub_editor/src/schema/opf/epub_metadata.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_contributor.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_date.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_identifier.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_meta.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_string.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_translated_string.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

main() async {
  final int length = 10;
  final RandomDataGenerator generator = RandomDataGenerator(
    Random(123778),
    length,
  );

  final reference = generator.randomEpubMetadata();
  EpubMetadata? testMetadata;

  setUp(() async {
    testMetadata = EpubMetadata(
      contributors: List.from(reference.contributors),
      coverages: List.from(reference.coverages),
      creators: List.from(reference.creators),
      dates: List.from(reference.dates),
      descriptions: List.from(reference.descriptions),
      formats: List.from(reference.formats),
      identifiers: List.from(reference.identifiers),
      languages: List.from(reference.languages),
      metaItems: List.from(reference.metaItems),
      publishers: List.from(reference.publishers),
      relations: List.from(reference.relations),
      rights: List.from(reference.rights),
      sources: List.from(reference.sources),
      subjects: List.from(reference.subjects),
      titles: List.from(reference.titles),
      types: List.from(reference.types),
    );
  });

  tearDown(() async {
    testMetadata = null;
  });

  group('EpubMetadata', () {
    group('.equals', () {
      test('is true for equivalent objects', () async {
        expect(testMetadata, equals(reference));
      });

      test('is false when Contributors changes', () async {
        testMetadata!.contributors = [EpubMetadataContributor()];
        expect(testMetadata, isNot(reference));
      });

      test('is false when Coverages changes', () async {
        testMetadata!.coverages = [EpubMetadataTranslatedString()];
        expect(testMetadata, isNot(reference));
      });

      test('is false when Creators changes', () async {
        testMetadata!.creators = [EpubMetadataContributor()];
        expect(testMetadata, isNot(reference));
      });

      test('is false when Dates changes', () async {
        testMetadata!.dates = [EpubMetadataDate()];
        expect(testMetadata, isNot(reference));
      });

      test('is false when Description changes', () async {
        testMetadata!.descriptions = [EpubMetadataTranslatedString()];
        expect(testMetadata, isNot(reference));
      });

      test('is false when Formats changes', () async {
        testMetadata!.formats = [EpubMetadataString()];
        expect(testMetadata, isNot(reference));
      });

      test('is false when Identifiers changes', () async {
        testMetadata!.identifiers = [EpubMetadataIdentifier()];
        expect(testMetadata, isNot(reference));
      });

      test('is false when Languages changes', () async {
        testMetadata!.languages = [EpubMetadataString()];
        expect(testMetadata, isNot(reference));
      });

      test('is false when MetaItems changes', () async {
        testMetadata!.metaItems = [EpubMetadataMeta()];
        expect(testMetadata, isNot(reference));
      });

      test('is false when Publishers changes', () async {
        testMetadata!.publishers = [EpubMetadataTranslatedString()];
        expect(testMetadata, isNot(reference));
      });

      test('is false when Relations changes', () async {
        testMetadata!.relations = [EpubMetadataTranslatedString()];
        expect(testMetadata, isNot(reference));
      });

      test('is false when Rights changes', () async {
        testMetadata!.rights = [EpubMetadataTranslatedString()];
        expect(testMetadata, isNot(reference));
      });

      test('is false when Sources changes', () async {
        testMetadata!.sources = [EpubMetadataString()];
        expect(testMetadata, isNot(reference));
      });

      test('is false when Subjects changes', () async {
        testMetadata!.subjects = [EpubMetadataTranslatedString()];
        expect(testMetadata, isNot(reference));
      });

      test('is false when Titles changes', () async {
        testMetadata!.titles = [EpubMetadataTranslatedString()];
        expect(testMetadata, isNot(reference));
      });

      test('is false when Types changes', () async {
        testMetadata!.types = [EpubMetadataString()];
        expect(testMetadata, isNot(reference));
      });
    });

    group('.hashCode', () {
      test('is true for equivalent objects', () async {
        expect(testMetadata!.hashCode, equals(reference.hashCode));
      });

      test('is false when Contributors changes', () async {
        testMetadata!.contributors = [EpubMetadataContributor()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });

      test('is false when Coverages changes', () async {
        testMetadata!.coverages = [EpubMetadataTranslatedString()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });

      test('is false when Creators changes', () async {
        testMetadata!.creators = [EpubMetadataContributor()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });

      test('is false when Dates changes', () async {
        testMetadata!.dates = [EpubMetadataDate()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });

      test('is false when Description changes', () async {
        testMetadata!.descriptions = [EpubMetadataTranslatedString()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });

      test('is false when Formats changes', () async {
        testMetadata!.formats = [EpubMetadataString()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });

      test('is false when Identifiers changes', () async {
        testMetadata!.identifiers = [EpubMetadataIdentifier()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });

      test('is false when Languages changes', () async {
        testMetadata!.languages = [EpubMetadataString()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });

      test('is false when MetaItems changes', () async {
        testMetadata!.metaItems = [EpubMetadataMeta()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });

      test('is false when Publishers changes', () async {
        testMetadata!.publishers = [EpubMetadataTranslatedString()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });

      test('is false when Relations changes', () async {
        testMetadata!.relations = [EpubMetadataTranslatedString()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });

      test('is false when Rights changes', () async {
        testMetadata!.rights = [EpubMetadataTranslatedString()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });

      test('is false when Sources changes', () async {
        testMetadata!.sources = [EpubMetadataString()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });

      test('is false when Subjects changes', () async {
        testMetadata!.subjects = [EpubMetadataTranslatedString()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });

      test('is false when Titles changes', () async {
        testMetadata!.titles = [EpubMetadataTranslatedString()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });

      test('is false when Types changes', () async {
        testMetadata!.types = [EpubMetadataString()];
        expect(testMetadata!.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
