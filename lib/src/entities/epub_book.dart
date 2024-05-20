import 'package:epub_editor/src/schema/opf/epub_metadata_translated_string.dart';
import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import '../ref_entities/epub_byte_content_file_ref.dart';
import 'epub_chapter.dart';
import 'epub_content.dart';
import 'epub_schema.dart';

class EpubBook {
  late EpubMetadataTranslatedString mainTitle;
  String? author;
  List<String?>? authorList;
  EpubSchema? schema;
  EpubContent? content;
  EpubByteContentFileRef? coverImage;
  List<EpubChapter>? chapters;

  @override
  int get hashCode {
    final objects = [
      mainTitle.hashCode,
      author.hashCode,
      schema.hashCode,
      content.hashCode,
      ...coverImage?.getContentStream().map((byte) => byte.hashCode) ?? [0],
      ...authorList?.map((author) => author.hashCode) ?? [0],
      ...chapters?.map((chapter) => chapter.hashCode) ?? [0],
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    if (!(other is EpubBook)) {
      return false;
    }

    return mainTitle == other.mainTitle &&
        author == other.author &&
        collections.listsEqual(authorList, other.authorList) &&
        schema == other.schema &&
        content == other.content &&
        collections.listsEqual(coverImage?.getContentStream(),
            other.coverImage?.getContentStream()) &&
        collections.listsEqual(chapters, other.chapters);
  }
}
