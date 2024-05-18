library epubreadertest;

import 'package:epub_editor/epub.dart';
import 'package:epub_editor/src/entities/epub_schema.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_doc_author.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_doc_title.dart';
import 'package:epub_editor/src/schema/opf/epub_guide.dart';
import 'package:epub_editor/src/schema/opf/epub_version.dart';
import 'package:test/test.dart';

main() async {
  final reference = new EpubSchema();
  reference
    ..package = new EpubPackage()
    ..navigation = new EpubNavigation()
    ..contentDirectoryPath = "some/random/path";
  reference.package.version = EpubVersion.epub2;

  EpubSchema testSchema;
  setUp(() async {
    testSchema = new EpubSchema();
    testSchema
      ..package = new EpubPackage()
      ..navigation = new EpubNavigation()
      ..contentDirectoryPath = "some/random/path";
    testSchema.package.version = EpubVersion.epub2;
  });
  tearDown(() async {
    testSchema = null;
  });
  group("EpubSchema", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testSchema, equals(reference));
      });

      test("is false when Package changes", () async {
        final package = new EpubPackage()
          ..guide = new Epu.guide()
          ..version = EpubVersion.epub3;

        testSchema.package = package;
        expect(testSchema, isNot(reference));
      });

      test("is false when Navigation changes", () async {
        testSchema.navigation = new EpubNavigation()
          ..docTitle = new EpubNavigationDocTitle()
          ..docAuthors = [new EpubNavigationDocAuthor()];

        expect(testSchema, isNot(reference));
      });

      test("is false when ContentDirectoryPath changes", () async {
        testSchema.contentDirectoryPath = "some/other/random/path/to/dev/null";
        expect(testSchema, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testSchema.hashCode, equals(reference.hashCode));
      });

      test("is false when Package changes", () async {
        final package = new EpubPackage()
          ..guide = new Epu.guide()
          ..version = EpubVersion.epub3;

        testSchema.package = package;
        expect(testSchema.hashCode, isNot(reference.hashCode));
      });

      test("is false when Navigation changes", () async {
        testSchema.navigation = new EpubNavigation()
          ..docTitle = new EpubNavigationDocTitle()
          ..docAuthors = [new EpubNavigationDocAuthor()];

        expect(testSchema.hashCode, isNot(reference.hashCode));
      });

      test("is false when ContentDirectoryPath changes", () async {
        testSchema.contentDirectoryPath = "some/other/random/path/to/dev/null";
        expect(testSchema.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
