import 'package:epub_editor/src/ref_entities/epub_book_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_chapter_ref.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_point.dart';

class ChapterReader {
  static List<EpubChapterRef> getChapters(EpubBookRef bookRef) {
    if (bookRef.schema!.navigation == null) {
      return [];
    }

    return getChaptersImpl(
      bookRef,
      bookRef.schema!.navigation!.navMap!.points!,
    );
  }

  static List<EpubChapterRef> getChaptersImpl(
    EpubBookRef bookRef,
    List<EpubNavigationPoint> navigationPoints,
  ) {
    final result = <EpubChapterRef>[];

    for (final navigationPoint in navigationPoints) {
      String? contentFileName;
      String? anchor;

      if (navigationPoint.content?.source == null) {
        continue;
      }

      final contentSourceAnchorCharIndex =
          navigationPoint.content!.source!.indexOf('#');

      if (contentSourceAnchorCharIndex == -1) {
        contentFileName = navigationPoint.content!.source;
        anchor = null;
      } else {
        contentFileName = navigationPoint.content!.source!
            .substring(0, contentSourceAnchorCharIndex);
        anchor = navigationPoint.content!.source!
            .substring(contentSourceAnchorCharIndex + 1);
      }

      contentFileName = Uri.decodeFull(contentFileName!);

      if (!bookRef.content!.html!.containsKey(contentFileName)) {
        throw Exception(
          'Incorrect EPUB manifest: item with href = \"$contentFileName\" is '
          'missing.',
        );
      }

      result.add(EpubChapterRef(
        epubTextContentFileRef: bookRef.content!.html![contentFileName],
        contentFileName: contentFileName,
        anchor: anchor,
        title: navigationPoint.navigationLabels!.first.text,
        subChapters: getChaptersImpl(
          bookRef,
          navigationPoint.childNavigationPoints!,
        ),
      ));
    }

    return result;
  }
}
