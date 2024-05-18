library epubreadertest;

import 'package:epub_editor/src/schema/opf/epub_metadata_contributor.dart';
import 'package:test/test.dart';

main() async {
  final reference = new EpubMetadataContributor()
    ..contributor = "orthros"
    ..fileAs = "Large"
    ..role = "Creator";

  EpubMetadataContributor testMetadataContributor;
  setUp(() async {
    testMetadataContributor = new EpubMetadataContributor()
      ..contributor = reference.contributor
      ..fileAs = reference.fileAs
      ..role = reference.role;
  });
  tearDown(() async {
    testMetadataContributor = null;
  });

  group("EpubMetadataContributor", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataContributor, equals(reference));
      });

      test("is false when Contributor changes", () async {
        testMetadataContributor.contributor = "NotOrthros";
        expect(testMetadataContributor, isNot(reference));
      });
      test("is false when FileAs changes", () async {
        testMetadataContributor.fileAs = "Small";
        expect(testMetadataContributor, isNot(reference));
      });
      test("is false when Role changes", () async {
        testMetadataContributor.role = "Copier";
        expect(testMetadataContributor, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataContributor.hashCode, equals(reference.hashCode));
      });

      test("is false when Contributor changes", () async {
        testMetadataContributor.contributor = "NotOrthros";
        expect(testMetadataContributor.hashCode, isNot(reference.hashCode));
      });
      test("is false when FileAs changes", () async {
        testMetadataContributor.fileAs = "Small";
        expect(testMetadataContributor.hashCode, isNot(reference.hashCode));
      });
      test("is false when Role changes", () async {
        testMetadataContributor.role = "Copier";
        expect(testMetadataContributor.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
