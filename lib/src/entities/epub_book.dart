import 'package:epub_editor/src/entities/epub_chapter.dart';
import 'package:epub_editor/src/entities/epub_content.dart';
import 'package:epub_editor/src/entities/epub_schema.dart';
import 'package:epub_editor/src/ref_entities/epub_byte_content_file_ref.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_translated_string.dart';
import 'package:quiver/collection.dart';

class EpubBook {
  EpubBook({
    required this.mainTitle,
    this.author,
    this.authorList,
    this.schema,
    this.content,
    this.coverImage,
    this.chapters,
  });

  EpubMetadataTranslatedString mainTitle;
  String? author;
  List<String?>? authorList;
  EpubSchema? schema;
  EpubContent? content;
  EpubByteContentFileRef? coverImage;
  List<EpubChapter>? chapters;

  @override
  int get hashCode => Object.hashAll([
        mainTitle.hashCode,
        author.hashCode,
        schema.hashCode,
        content.hashCode,
        ...coverImage?.getContentStream().map((byte) => byte.hashCode) ?? [0],
        ...authorList?.map((author) => author.hashCode) ?? [0],
        ...chapters?.map((chapter) => chapter.hashCode) ?? [0],
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubBook)) {
      return false;
    }

    return mainTitle == other.mainTitle &&
        author == other.author &&
        listsEqual(authorList, other.authorList) &&
        schema == other.schema &&
        content == other.content &&
        listsEqual(coverImage?.getContentStream(),
            other.coverImage?.getContentStream()) &&
        listsEqual(chapters, other.chapters);
  }
}
