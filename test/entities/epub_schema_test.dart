library epubreadertest;

import 'package:epub_editor/src/entities/epub_schema.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_doc_author.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_doc_title.dart';
import 'package:epub_editor/src/schema/opf/epub_guide.dart';
import 'package:epub_editor/src/schema/opf/epub_package.dart';
import 'package:epub_editor/src/utils/types/epub_version.dart';
import 'package:test/test.dart';

main() async {
  final reference = EpubSchema(
    package: EpubPackage(version: EpubVersion.epub2),
    navigation: EpubNavigation(),
    contentDirectoryPath: 'some/random/path',
  );

  EpubSchema? testSchema;

  setUp(() async {
    testSchema = EpubSchema(
      package: EpubPackage(version: EpubVersion.epub2),
      navigation: EpubNavigation(),
      contentDirectoryPath: 'some/random/path',
    );
  });

  tearDown(() async {
    testSchema = null;
  });

  group('EpubSchema', () {
    group('.equals', () {
      test('is true for equivalent objects', () async {
        expect(testSchema, equals(reference));
      });

      test('is false when Package changes', () async {
        final package = EpubPackage(
          guide: EpubGuide(),
          version: EpubVersion.epub3,
        );

        testSchema!.package = package;
        expect(testSchema, isNot(reference));
      });

      test('is false when Navigation changes', () async {
        testSchema!.navigation = EpubNavigation(
          docTitle: EpubNavigationDocTitle(),
          docAuthors: [EpubNavigationDocAuthor()],
        );

        expect(testSchema, isNot(reference));
      });

      test('is false when ContentDirectoryPath changes', () async {
        testSchema!.contentDirectoryPath = 'some/other/random/path/to/dev/null';
        expect(testSchema, isNot(reference));
      });
    });

    group('.hashCode', () {
      test('is true for equivalent objects', () async {
        expect(testSchema.hashCode, equals(reference.hashCode));
      });

      test('is false when Package changes', () async {
        final package = EpubPackage(
          guide: EpubGuide(),
          version: EpubVersion.epub3,
        );

        testSchema!.package = package;
        expect(testSchema.hashCode, isNot(reference.hashCode));
      });

      test('is false when Navigation changes', () async {
        testSchema!.navigation = EpubNavigation(
          docTitle: EpubNavigationDocTitle(),
          docAuthors: [EpubNavigationDocAuthor()],
        );

        expect(testSchema.hashCode, isNot(reference.hashCode));
      });

      test('is false when ContentDirectoryPath changes', () async {
        testSchema!.contentDirectoryPath = 'some/other/random/path/to/dev/null';
        expect(testSchema.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
