library epubreadertest;

import 'package:epub_editor/src/entities/epub_chapter.dart';
import 'package:test/test.dart';

main() async {
  final reference = EpubChapter(
    anchor: "anchor",
    contentFileName: "orthros",
    htmlContent: "<html></html>",
    title: "A New Look at Chapters",
  );

  EpubChapter? testChapter;

  setUp(() async {
    testChapter = EpubChapter(
      anchor: "anchor",
      contentFileName: "orthros",
      htmlContent: "<html></html>",
      title: "A New Look at Chapters",
    );
  });

  tearDown(() async {
    testChapter = null;
  });

  group("EpubChapter", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testChapter, equals(reference));
      });

      test("is false when HtmlContent changes", () async {
        testChapter!.htmlContent =
            "<html>I'm sure this isn't valid Html</html>";
        expect(testChapter, isNot(reference));
      });

      test("is false when Anchor changes", () async {
        testChapter!.anchor = "NotAnAnchor";
        expect(testChapter, isNot(reference));
      });

      test("is false when ContentFileName changes", () async {
        testChapter!.contentFileName = "NotOrthros";
        expect(testChapter, isNot(reference));
      });

      test("is false when SubChapters changes", () async {
        testChapter!.subChapters = [
          EpubChapter(
            title: "A Brave new Epub",
            contentFileName: "orthros.txt",
          )
        ];

        expect(testChapter, isNot(reference));
      });

      test("is false when Title changes", () async {
        testChapter!.title = "A Boring Old World";
        expect(testChapter, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testChapter.hashCode, equals(reference.hashCode));
      });

      test("is true for equivalent objects", () async {
        expect(testChapter.hashCode, equals(reference.hashCode));
      });

      test("is false when HtmlContent changes", () async {
        testChapter!.htmlContent =
            "<html>I'm sure this isn't valid Html</html>";
        expect(testChapter.hashCode, isNot(reference.hashCode));
      });

      test("is false when Anchor changes", () async {
        testChapter!.anchor = "NotAnAnchor";
        expect(testChapter.hashCode, isNot(reference.hashCode));
      });

      test("is false when ContentFileName changes", () async {
        testChapter!.contentFileName = "NotOrthros";
        expect(testChapter.hashCode, isNot(reference.hashCode));
      });

      test("is false when SubChapters changes", () async {
        testChapter!.subChapters = [
          EpubChapter(
            title: "A Brave new Epub",
            contentFileName: "orthros.txt",
          )
        ];

        expect(testChapter.hashCode, isNot(reference.hashCode));
      });

      test("is false when Title changes", () async {
        testChapter!.title = "A Boring Old World";
        expect(testChapter.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
