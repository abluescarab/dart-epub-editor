import 'package:epub_editor/src/entities/epub_chapter.dart';
import 'package:epub_editor/src/entities/epub_content.dart';
import 'package:epub_editor/src/entities/epub_schema.dart';
import 'package:epub_editor/src/ref_entities/epub_byte_content_file_ref.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_translated_string.dart';
import 'package:quiver/collection.dart';

class EpubBook {
  EpubBook({
    EpubSchema? schema,
    EpubContent? content,
    List<EpubChapter>? chapters,
    this.mainTitle,
    this.authors,
    this.coverImage,
  })  : this.schema = schema ?? EpubSchema(),
        this.content = content ?? EpubContent(),
        this.chapters = chapters ?? [];

  EpubSchema schema;
  EpubContent content;
  List<EpubChapter> chapters;

  EpubMetadataTranslatedString? mainTitle;
  List<String?>? authors;
  EpubByteContentFileRef? coverImage;

  @override
  int get hashCode => Object.hashAll([
        schema.hashCode,
        content.hashCode,
        mainTitle.hashCode,
        ...chapters.map((chapter) => chapter.hashCode),
        ...authors?.map((author) => author.hashCode) ?? [0],
        ...coverImage?.getContentStream().map((byte) => byte.hashCode) ?? [0],
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubBook)) {
      return false;
    }

    return schema == other.schema &&
        content == other.content &&
        mainTitle == other.mainTitle &&
        listsEqual(authors, other.authors) &&
        listsEqual(coverImage?.getContentStream(),
            other.coverImage?.getContentStream()) &&
        listsEqual(chapters, other.chapters);
  }
}
