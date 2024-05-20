library epubreadertest;

import 'package:epub_editor/src/schema/opf/epub_metadata_contributor.dart';
import 'package:test/test.dart';

main() async {
  final reference = EpubMetadataContributor()
    ..name = "orthros"
    ..fileAs = "Large"
    ..role = "Creator";

  EpubMetadataContributor? testMetadataCreator;
  setUp(() async {
    testMetadataCreator = EpubMetadataContributor()
      ..name = reference.name
      ..fileAs = reference.fileAs
      ..role = reference.role;
  });
  tearDown(() async {
    testMetadataCreator = null;
  });

  group("EpubMetadataContributor", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataCreator, equals(reference));
      });

      test("is false when Creator changes", () async {
        testMetadataCreator!.name = "NotOrthros";
        expect(testMetadataCreator, isNot(reference));
      });
      test("is false when FileAs changes", () async {
        testMetadataCreator!.fileAs = "Small";
        expect(testMetadataCreator, isNot(reference));
      });
      test("is false when Role changes", () async {
        testMetadataCreator!.role = "Copier";
        expect(testMetadataCreator, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataCreator!.hashCode, equals(reference.hashCode));
      });

      test("is false when Creator changes", () async {
        testMetadataCreator!.name = "NotOrthros";
        expect(testMetadataCreator!.hashCode, isNot(reference.hashCode));
      });
      test("is false when FileAs changes", () async {
        testMetadataCreator!.fileAs = "Small";
        expect(testMetadataCreator!.hashCode, isNot(reference.hashCode));
      });
      test("is false when Role changes", () async {
        testMetadataCreator!.role = "Copier";
        expect(testMetadataCreator!.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
