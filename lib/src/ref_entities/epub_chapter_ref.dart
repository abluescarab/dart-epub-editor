import 'package:epub_editor/src/ref_entities/epub_text_content_file_ref.dart';
import 'package:quiver/collection.dart';

class EpubChapterRef {
  EpubChapterRef({
    List<EpubChapterRef>? subChapters,
    this.epubTextContentFileRef,
    this.title,
    this.contentFileName,
    this.anchor,
  }) : this.subChapters = subChapters ?? [];

  List<EpubChapterRef> subChapters;

  EpubTextContentFileRef? epubTextContentFileRef;
  String? title;
  String? contentFileName;
  String? anchor;

  @override
  int get hashCode => Object.hashAll([
        epubTextContentFileRef.hashCode,
        title.hashCode,
        contentFileName.hashCode,
        anchor.hashCode,
        ...subChapters.map((subChapter) => subChapter.hashCode),
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubChapterRef)) {
      return false;
    }

    return title == other.title &&
        contentFileName == other.contentFileName &&
        anchor == other.anchor &&
        epubTextContentFileRef == other.epubTextContentFileRef &&
        listsEqual(subChapters, other.subChapters);
  }

  Future<String> readHtmlContent() async {
    return epubTextContentFileRef!.readContentAsText();
  }

  @override
  String toString() {
    return 'Title: $title, Subchapter count: ${subChapters.length}';
  }
}
