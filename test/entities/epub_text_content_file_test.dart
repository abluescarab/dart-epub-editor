library epubreadertest;

import 'package:epub_editor/src/entities/epub_content_type.dart';
import 'package:epub_editor/src/entities/epub_text_content_file.dart';
import 'package:test/test.dart';

main() async {
  final reference = EpubTextContentFile();
  reference
    ..content = "Hello"
    ..contentMimeType = "application/test"
    ..contentType = EpubContentType.other
    ..fileName = "orthrosFile";
  EpubTextContentFile? testFile;
  setUp(() async {
    testFile = EpubTextContentFile();
    testFile!
      ..content = "Hello"
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

      test("is false when Content changes", () async {
        testFile!.content = "Goodbye";
        expect(testFile, isNot(reference));
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
        expect(testFile.hashCode, equals(reference.hashCode));
      });

      test('changes when Content changes', () async {
        testFile!.content = "Goodbye";
        expect(testFile.hashCode, isNot(reference.hashCode));
      });

      test('changes when ContentMimeType changes', () async {
        testFile!.contentMimeType = "application/orthros";
        expect(testFile.hashCode, isNot(reference.hashCode));
      });

      test('changes when ContentType changes', () async {
        testFile!.contentType = EpubContentType.css;
        expect(testFile.hashCode, isNot(reference.hashCode));
      });

      test('changes when FileName changes', () async {
        testFile!.fileName = "a_different_file_name";
        expect(testFile.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
