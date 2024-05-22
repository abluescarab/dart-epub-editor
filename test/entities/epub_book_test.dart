library epubreadertest;

import 'package:epub_editor/src/entities/epub_book.dart';
import 'package:epub_editor/src/entities/epub_chapter.dart';
import 'package:epub_editor/src/entities/epub_content.dart';
import 'package:epub_editor/src/utils/types/epub_content_type.dart';
import 'package:epub_editor/src/entities/epub_schema.dart';
import 'package:epub_editor/src/entities/epub_text_content_file.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_translated_string.dart';
import 'package:test/test.dart';

main() async {
  final reference = EpubBook(
    author: "orthros",
    authorList: ["orthros"],
    chapters: [EpubChapter()],
    content: EpubContent(),
    // coverImage = Image(width: 100, height: 100),
    schema: EpubSchema(),
    mainTitle: EpubMetadataTranslatedString(value: "A Dissertation on Epubs"),
  );

  EpubBook? testBook;

  setUp(() async {
    testBook = EpubBook(
      author: "orthros",
      authorList: ["orthros"],
      chapters: [EpubChapter()],
      content: EpubContent(),
      // coverImage = Image(width: 100, height: 100),
      schema: EpubSchema(),
      mainTitle: EpubMetadataTranslatedString(value: "A Dissertation on Epubs"),
    );
  });

  tearDown(() async {
    testBook = null;
  });

  group("EpubBook", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testBook, equals(reference));
      });

      test("is false when Content changes", () async {
        testBook!.content = EpubContent(allFiles: {
          "hello": EpubTextContentFile(
            content: "Hello",
            contentMimeType: "application/txt",
            contentType: EpubContentType.other,
            fileName: "orthros.txt",
          )
        });

        expect(testBook, isNot(reference));
      });

      test("is false when Author changes", () async {
        testBook!.author = "NotOrthros";
        expect(testBook, isNot(reference));
      });

      test("is false when AuthorList changes", () async {
        testBook!.authorList = ["NotOrthros"];
        expect(testBook, isNot(reference));
      });

      test("is false when Chapters changes", () async {
        testBook!.chapters = [
          EpubChapter(
            title: "A Brave new Epub",
            contentFileName: "orthros.txt",
          )
        ];

        expect(testBook, isNot(reference));
      });

      // test("is false when CoverImage changes", () async {
      //   testBook!.coverImage = Image(width: 200, height: 200);
      //   expect(testBook, isNot(reference));
      // });

      test("is false when Schema changes", () async {
        testBook!.schema = EpubSchema(contentDirectoryPath: "some/random/path");
        expect(testBook, isNot(reference));
      });

      test("is false when Title changes", () async {
        testBook!.mainTitle =
            EpubMetadataTranslatedString(value: "The Philosophy of Epubs");
        expect(testBook, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testBook.hashCode, equals(reference.hashCode));
      });

      test("is false when Content changes", () async {
        testBook!.content = EpubContent(allFiles: {
          "hello": EpubTextContentFile(
            content: "Hello",
            contentMimeType: "application/txt",
            contentType: EpubContentType.other,
            fileName: "orthros.txt",
          )
        });

        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Author changes", () async {
        testBook!.author = "NotOrthros";
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when AuthorList changes", () async {
        testBook!.authorList = ["NotOrthros"];
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Chapters changes", () async {
        testBook!.chapters = [
          EpubChapter(
            title: "A Brave new Epub",
            contentFileName: "orthros.txt",
          )
        ];

        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      // test("is false when CoverImage changes", () async {
      //   testBook!.coverImage = Image(width: 200, height: 200);
      //   expect(testBook.hashCode, isNot(reference.hashCode));
      // });

      test("is false when Schema changes", () async {
        testBook!.schema = EpubSchema(contentDirectoryPath: "some/random/path");
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Title changes", () async {
        testBook!.mainTitle =
            EpubMetadataTranslatedString(value: "The Philosophy of Epubs");
        expect(testBook.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
