import 'package:quiver/collection.dart';

class EpubChapter {
  EpubChapter({
    this.title,
    this.contentFileName,
    this.anchor,
    this.htmlContent,
    List<EpubChapter>? subChapters,
  }) : this.subChapters = subChapters ?? [];

  String? title;
  String? contentFileName;
  String? anchor;
  String? htmlContent;
  List<EpubChapter> subChapters;

  @override
  int get hashCode => Object.hashAll([
        title.hashCode,
        contentFileName.hashCode,
        anchor.hashCode,
        htmlContent.hashCode,
        ...subChapters.map((subChapter) => subChapter.hashCode),
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubChapter)) {
      return false;
    }

    return title == other.title &&
        contentFileName == other.contentFileName &&
        anchor == other.anchor &&
        htmlContent == other.htmlContent &&
        listsEqual(subChapters, other.subChapters);
  }

  @override
  String toString() {
    return 'Title: $title, Subchapter count: ${subChapters.length}';
  }
}
