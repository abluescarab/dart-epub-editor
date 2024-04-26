library epubreadertest;

import 'package:epub_editor/src/schema/opf/epub_metadata_identifier.dart';
import 'package:test/test.dart';

main() async {
  var reference = new EpubMetadataIdentifier()
    ..id = "Unique"
    ..identifier = "Identifier"
    ..scheme = "A plot";

  EpubMetadataIdentifier testMetadataIdentifier;
  setUp(() async {
    testMetadataIdentifier = new EpubMetadataIdentifier()
      ..id = reference.id
      ..identifier = reference.identifier
      ..scheme = reference.scheme;
  });
  tearDown(() async {
    testMetadataIdentifier = null;
  });

  group("EpubMetadataIdentifier", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataIdentifier, equals(reference));
      });

      test("is false when Id changes", () async {
        testMetadataIdentifier.id = "A different ID";
        expect(testMetadataIdentifier, isNot(reference));
      });
      test("is false when Identifier changes", () async {
        testMetadataIdentifier.identifier = "A different identifier";
        expect(testMetadataIdentifier, isNot(reference));
      });
      test("is false when Scheme changes", () async {
        testMetadataIdentifier.scheme = "A strange scheme";
        expect(testMetadataIdentifier, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataIdentifier.hashCode, equals(reference.hashCode));
      });

      test("is false when Id changes", () async {
        testMetadataIdentifier.id = "A different Id";
        expect(testMetadataIdentifier.hashCode, isNot(reference.hashCode));
      });
      test("is false when Identifier changes", () async {
        testMetadataIdentifier.identifier = "A different identifier";
        expect(testMetadataIdentifier.hashCode, isNot(reference.hashCode));
      });
      test("is false when Scheme changes", () async {
        testMetadataIdentifier.scheme = "A strange scheme";
        expect(testMetadataIdentifier.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
