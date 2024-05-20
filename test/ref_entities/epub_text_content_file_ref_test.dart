library epubreadertest;

import 'package:archive/archive.dart';
import 'package:epub_editor/src/entities/epub_content_type.dart';
import 'package:epub_editor/src/ref_entities/epub_book_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_text_content_file_ref.dart';
import 'package:test/test.dart';

main() async {
  final arch = Archive();
  final epubRef = EpubBookRef(arch);

  final reference = EpubTextContentFileRef(epubRef);
  reference
    ..contentMimeType = "application/test"
    ..contentType = EpubContentType.other
    ..fileName = "orthrosFile";
  EpubTextContentFileRef? testFile;

  setUp(() async {
    final arch2 = Archive();
    final epubRef2 = EpubBookRef(arch2);

    testFile = EpubTextContentFileRef(epubRef2);
    testFile!
      ..contentMimeType = "application/test"
      ..contentType = EpubContentType.other
      ..fileName = "orthrosFile";
  });

  tearDown(() async {
    testFile = null;
  });
  group("EpubTextContentFile", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testFile, equals(reference));
      });

      test("is false when ContentMimeType changes", () async {
        testFile!.contentMimeType = "application/different";
        expect(testFile, isNot(reference));
      });

      test("is false when ContentType changes", () async {
        testFile!.contentType = EpubContentType.css;
        expect(testFile, isNot(reference));
      });

      test("is false when FileName changes", () async {
        testFile!.fileName = "a_different_file_name.txt";
        expect(testFile, isNot(reference));
      });
    });
    group(".hashCode", () {
      test("is the same for equivalent content", () async {
        expect(testFile!.hashCode, equals(reference.hashCode));
      });

      test('changes when ContentMimeType changes', () async {
        testFile!.contentMimeType = "application/orthros";
        expect(testFile!.hashCode, isNot(reference.hashCode));
      });

      test('changes when ContentType changes', () async {
        testFile!.contentType = EpubContentType.css;
        expect(testFile!.hashCode, isNot(reference.hashCode));
      });

      test('changes when FileName changes', () async {
        testFile!.fileName = "a_different_file_name";
        expect(testFile!.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
