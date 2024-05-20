library epubreadertest;

import 'package:archive/archive.dart';
import 'package:epub_editor/src/entities/epub_content_type.dart';
import 'package:epub_editor/src/entities/epub_schema.dart';
import 'package:epub_editor/src/ref_entities/epub_book_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_content_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_text_content_file_ref.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_translated_string.dart';
import 'package:test/test.dart';

main() async {
  Archive arch = Archive();
  final reference = EpubBookRef(arch);
  reference
    ..author = "orthros"
    ..authorList = ["orthros"]
    ..schema = EpubSchema()
    ..title = EpubMetadataTranslatedString(value: "A Dissertation on Epubs");

  EpubBookRef? testBookRef;
  setUp(() async {
    testBookRef = EpubBookRef(arch);
    testBookRef!
      ..author = "orthros"
      ..authorList = ["orthros"]
      ..schema = EpubSchema()
      ..title = EpubMetadataTranslatedString(value: "A Dissertation on Epubs");
  });
  tearDown(() async {
    testBookRef = null;
  });
  group("EpubBookRef", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testBookRef, equals(reference));
      });

      test("is false when Content changes", () async {
        final file = EpubTextContentFileRef(testBookRef!);
        file
          ..contentMimeType = "application/txt"
          ..contentType = EpubContentType.other
          ..fileName = "orthros.txt";

        EpubContentRef content = EpubContentRef();
        content.allFiles!["hello"] = file;

        testBookRef!.content = content;

        expect(testBookRef, isNot(reference));
      });

      test("is false when Author changes", () async {
        testBookRef!.author = "NotOrthros";
        expect(testBookRef, isNot(reference));
      });

      test("is false when AuthorList changes", () async {
        testBookRef!.authorList = ["NotOrthros"];
        expect(testBookRef, isNot(reference));
      });

      test("is false when Schema changes", () async {
        final schema = EpubSchema();
        schema.contentDirectoryPath = "some/random/path";
        testBookRef!.schema = schema;
        expect(testBookRef, isNot(reference));
      });

      test("is false when Title changes", () async {
        testBookRef!.title =
            EpubMetadataTranslatedString(value: "The Philosophy of Epubs");
        expect(testBookRef, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testBookRef.hashCode, equals(reference.hashCode));
      });

      test("is false when Content changes", () async {
        final file = EpubTextContentFileRef(testBookRef!);
        file
          ..contentMimeType = "application/txt"
          ..contentType = EpubContentType.other
          ..fileName = "orthros.txt";

        EpubContentRef content = EpubContentRef();
        content.allFiles!["hello"] = file;

        testBookRef!.content = content;

        expect(testBookRef, isNot(reference));
      });

      test("is false when Author changes", () async {
        testBookRef!.author = "NotOrthros";
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });

      test("is false when AuthorList changes", () async {
        testBookRef!.authorList = ["NotOrthros"];
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });
      test("is false when Schema changes", () async {
        final schema = EpubSchema();
        schema.contentDirectoryPath = "some/random/path";
        testBookRef!.schema = schema;
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });

      test("is false when Title changes", () async {
        testBookRef!.title =
            EpubMetadataTranslatedString(value: "The Philosophy of Epubs");
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
