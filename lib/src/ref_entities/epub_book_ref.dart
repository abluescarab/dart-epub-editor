import 'dart:async';

import 'package:archive/archive.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_string.dart';
import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import '../entities/epub_schema.dart';
import '../readers/book_cover_reader.dart';
import '../readers/chapter_reader.dart';
import 'epub_byte_content_file_ref.dart';
import 'epub_chapter_ref.dart';
import 'epub_content_ref.dart';

class EpubBookRef {
  Archive? _epubArchive;

  /// Main title.
  EpubMetadataString? title;
  String? author;
  List<String?>? authorList;
  EpubSchema? schema;
  EpubContentRef? content;
  EpubBookRef(Archive epubArchive) {
    _epubArchive = epubArchive;
  }

  @override
  int get hashCode {
    var objects = [
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

  Archive? epubArchive() {
    return _epubArchive;
  }

  Future<List<EpubChapterRef>> getChapters() async {
    return ChapterReader.getChapters(this);
  }

  Future<EpubByteContentFileRef?> readCover() async {
    return await BookCoverReader.readBookCover(this);
  }
}
