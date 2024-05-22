import 'package:quiver/collection.dart';

class EpubChapter {
  EpubChapter({
    List<EpubChapter>? subChapters,
    this.title,
    this.contentFileName,
    this.anchor,
    this.htmlContent,
  }) : this.subChapters = subChapters ?? [];

  List<EpubChapter> subChapters;

  String? anchor;
  String? contentFileName;
  String? htmlContent;
  String? title;

  @override
  int get hashCode => Object.hashAll([
        anchor.hashCode,
        contentFileName.hashCode,
        htmlContent.hashCode,
        title.hashCode,
        ...subChapters.map((subChapter) => subChapter.hashCode),
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubChapter)) {
      return false;
    }

    return anchor == other.anchor &&
        contentFileName == other.contentFileName &&
        htmlContent == other.htmlContent &&
        title == other.title &&
        listsEqual(subChapters, other.subChapters);
  }

  @override
  String toString() {
    return 'Title: $title, Subchapter count: ${subChapters.length}';
  }
}
