import 'dart:async';
import 'dart:convert' as convert;

import 'package:archive/archive.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:quiver/core.dart';

import '../entities/epub_content_type.dart';
import '../utils/zip_path_utils.dart';
import 'epub_book_ref.dart';

abstract class EpubContentFileRef {
  late EpubBookRef epubBookRef;

  String? fileName;

  EpubContentType? contentType;
  String? contentMimeType;

  EpubContentFileRef(EpubBookRef epubBookRef) {
    this.epubBookRef = epubBookRef;
  }

  @override
  int get hashCode =>
      hash3(fileName.hashCode, contentMimeType.hashCode, contentType.hashCode);

  @override
  bool operator ==(other) {
    if (!(other is EpubContentFileRef)) {
      return false;
    }

    return (other.fileName == fileName &&
        other.contentMimeType == contentMimeType &&
        other.contentType == contentType);
  }

  ArchiveFile getContentFileEntry() {
    final contentFilePath = ZipPathUtils.combine(
        epubBookRef.schema!.contentDirectoryPath, fileName);
    final contentFileEntry = epubBookRef.archive.files
        .firstWhereOrNull((ArchiveFile x) => x.name == contentFilePath);
    if (contentFileEntry == null) {
      throw Exception(
          'EPUB parsing error: file $contentFilePath not found in archive.');
    }
    return contentFileEntry;
  }

  List<int> getContentStream() {
    return openContentStream(getContentFileEntry());
  }

  List<int> openContentStream(ArchiveFile contentFileEntry) {
    final contentStream = <int>[];
    if (contentFileEntry.content == null) {
      throw Exception(
          'Incorrect EPUB file: content file \"$fileName\" specified in manifest is not found.');
    }
    contentStream.addAll(contentFileEntry.content);
    return contentStream;
  }

  Future<List<int>> readContentAsBytes() async {
    final contentFileEntry = getContentFileEntry();
    final content = openContentStream(contentFileEntry);
    return content;
  }

  Future<String> readContentAsText() async {
    final contentStream = getContentStream();
    final result = convert.utf8.decode(contentStream);
    return result;
  }
}
