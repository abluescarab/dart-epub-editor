library epubreadertest;

import 'package:archive/archive.dart';
import 'package:epub_editor/src/entities/epub_content_type.dart';
import 'package:epub_editor/src/ref_entities/epub_book_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_byte_content_file_ref.dart';
import 'package:test/test.dart';

main() async {
  Archive arch = Archive();
  EpubBookRef ref = EpubBookRef(arch);

  final reference = EpubByteContentFileRef(ref);
  reference
    ..contentMimeType = "application/test"
    ..contentType = EpubContentType.other
    ..fileName = "orthrosFile";

  EpubByteContentFileRef? testFileRef;

  setUp(() async {
    Archive arch2 = Archive();
    EpubBookRef ref2 = EpubBookRef(arch2);

    testFileRef = EpubByteContentFileRef(ref2);
    testFileRef
      !..contentMimeType = "application/test"
      ..contentType = EpubContentType.other
      ..fileName = "orthrosFile";
  });

  tearDown(() async {
    testFileRef = null;
  });

  group("EpubByteContentFileRef", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testFileRef, equals(reference));
      });

      test("is false when ContentMimeType changes", () async {
        testFileRef!.contentMimeType = "application/different";
        expect(testFileRef, isNot(reference));
      });

      test("is false when ContentType changes", () async {
        testFileRef!.contentType = EpubContentType.css;
        expect(testFileRef, isNot(reference));
      });

      test("is false when FileName changes", () async {
        testFileRef!.fileName = "a_different_file_name.txt";
        expect(testFileRef, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is the same for equivalent content", () async {
        expect(testFileRef.hashCode, equals(reference.hashCode));
      });

      test('changes when ContentMimeType changes', () async {
        testFileRef!.contentMimeType = "application/orthros";
        expect(testFileRef.hashCode, isNot(reference.hashCode));
      });

      test('changes when ContentType changes', () async {
        testFileRef!.contentType = EpubContentType.css;
        expect(testFileRef.hashCode, isNot(reference.hashCode));
      });

      test('changes when FileName changes', () async {
        testFileRef!.fileName = "a_different_file_name";
        expect(testFileRef.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
