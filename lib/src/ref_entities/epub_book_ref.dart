import 'dart:async';

import 'package:archive/archive.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_translated_string.dart';
import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import '../entities/epub_schema.dart';
import '../readers/book_cover_reader.dart';
import '../readers/chapter_reader.dart';
import 'epub_byte_content_file_ref.dart';
import 'epub_chapter_ref.dart';
import 'epub_content_ref.dart';

class EpubBookRef {
  EpubBookRef(Archive epubArchive) {
    _epubArchive = epubArchive;
  }

  /// Main title.
  EpubMetadataTranslatedString? title;
  String? author;
  List<String?>? authorList;
  EpubSchema? schema;
  EpubContentRef? content;

  late Archive _epubArchive;

  Archive get archive => _epubArchive;

  @override
  int get hashCode {
    final objects = [
      title.hashCode,
      author.hashCode,
      schema.hashCode,
      content.hashCode,
      ...authorList?.map((author) => author.hashCode) ?? [0],
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    if (!(other is EpubBookRef)) {
      return false;
    }

    return title == other.title &&
        author == other.author &&
        schema == other.schema &&
        content == other.content &&
        collections.listsEqual(authorList, other.authorList);
  }

  Future<List<EpubChapterRef>> getChapters() async {
    return ChapterReader.getChapters(this);
  }

  Future<EpubByteContentFileRef?> readCover() async {
    return await BookCoverReader.readBookCover(this);
  }
}
