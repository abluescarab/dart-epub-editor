import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:epub_editor/epub_editor.dart';
import 'package:epub_editor/src/utils/zip_path_utils.dart';
import 'package:quiver/core.dart';

abstract class EpubContentFileRef {
  EpubContentFileRef({
    required this.epubBookRef,
    this.fileName,
    this.contentType,
    this.contentMimeType,
  });

  EpubBookRef epubBookRef;
  String? fileName;
  EpubContentType? contentType;
  String? contentMimeType;

  @override
  int get hashCode => hash4(
        epubBookRef.hashCode,
        fileName.hashCode,
        contentMimeType.hashCode,
        contentType.hashCode,
      );

  @override
  bool operator ==(other) {
    if (!(other is EpubContentFileRef)) {
      return false;
    }

    return epubBookRef == other.epubBookRef &&
        fileName == other.fileName &&
        contentMimeType == other.contentMimeType &&
        contentType == other.contentType;
  }

  ArchiveFile getContentFileEntry() {
    final contentFilePath = ZipPathUtils.combine(
      epubBookRef.schema.contentDirectoryPath,
      fileName,
    );

    final contentFileEntry = epubBookRef.archive.files.firstWhereOrNull(
      (x) => x.name == contentFilePath,
    );

    if (contentFileEntry == null) {
      throw Exception(
        'EPUB parsing error: file $contentFilePath not found in archive.',
      );
    }

    return contentFileEntry;
  }

  List<int> getContentStream() {
    return openContentStream(getContentFileEntry());
  }

  List<int> openContentStream(ArchiveFile contentFileEntry) {
    if (contentFileEntry.content == null) {
      throw Exception(
        'Incorrect EPUB file: content file \"$fileName\" specified in manifest '
        'is not found.',
      );
    }

    return contentFileEntry.content;
  }

  Future<List<int>> readContentAsBytes() async {
    return openContentStream(getContentFileEntry());
  }

  Future<String> readContentAsText() async {
    return utf8.decode(getContentStream());
  }
}
