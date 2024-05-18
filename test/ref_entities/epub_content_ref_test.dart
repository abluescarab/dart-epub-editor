library epubreadertest;

import 'package:archive/archive.dart';
import 'package:epub_editor/epub.dart';
import 'package:epub_editor/src/ref_entities/epub_byte_content_file_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_content_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_text_content_file_ref.dart';
import 'package:test/test.dart';

main() async {
  final reference = new EpubContentRef();

  EpubContentRef testContent;
  EpubTextContentFileRef textContentFile;
  EpubByteContentFileRef byteContentFile;

  setUp(() async {
    final arch = new Archive();
    final refBook = new EpubBookRef(arch);

    testContent = new EpubContentRef();

    textContentFile = new EpubTextContentFileRef(refBook)
      ..contentMimeType = "application/text"
      ..contentType = EpubContentType.other
      ..fileName = "orthros.txt";

    byteContentFile = new EpubByteContentFileRef(refBook)
      ..contentMimeType = "application/orthros"
      ..contentType = EpubContentType.other
      ..fileName = "orthros.bin";
  });

  tearDown(() async {
    testContent = null;
    textContentFile = null;
    byteContentFile = null;
  });
  group("EpubContentRef", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testContent, equals(reference));
      });

      test("is false when Html changes", () async {
        testContent.html["someKey"] = textContentFile;
        expect(testContent, isNot(reference));
      });

      test("is false when Css changes", () async {
        testContent.css["someKey"] = textContentFile;
        expect(testContent, isNot(reference));
      });

      test("is false when Images changes", () async {
        testContent.images["someKey"] = byteContentFile;
        expect(testContent, isNot(reference));
      });

      test("is false when Fonts changes", () async {
        testContent.fonts["someKey"] = byteContentFile;
        expect(testContent, isNot(reference));
      });

      test("is false when AllFiles changes", () async {
        testContent.allFiles["someKey"] = byteContentFile;
        expect(testContent, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testContent.hashCode, equals(reference.hashCode));
      });

      test("is false when Html changes", () async {
        testContent.html["someKey"] = textContentFile;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when Css changes", () async {
        testContent.css["someKey"] = textContentFile;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when Images changes", () async {
        testContent.images["someKey"] = byteContentFile;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when Fonts changes", () async {
        testContent.fonts["someKey"] = byteContentFile;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when AllFiles changes", () async {
        testContent.allFiles["someKey"] = byteContentFile;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
