import 'dart:async';

import 'package:archive/archive.dart';
import 'package:epub_editor/src/entities/epub_book.dart';
import 'package:epub_editor/src/entities/epub_byte_content_file.dart';
import 'package:epub_editor/src/entities/epub_chapter.dart';
import 'package:epub_editor/src/entities/epub_content.dart';
import 'package:epub_editor/src/entities/epub_content_file.dart';
import 'package:epub_editor/src/entities/epub_text_content_file.dart';
import 'package:epub_editor/src/readers/schema_reader.dart';
import 'package:epub_editor/src/ref_entities/epub_book_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_byte_content_file_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_chapter_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_content_file_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_content_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_text_content_file_ref.dart';

/// A class that provides the primary interface to read Epub files.
///
/// To open an Epub and load all data at once use the [readBook()] method.
///
/// To open an Epub and load only basic metadata use the [openBook()] method.
/// This is a good option to quickly load text-based metadata, while leaving the
/// heavier lifting of loading images and main content for subsequent operations.
///
/// ## Example
/// ```dart
/// // Read the basic metadata.
/// EpubBookRef epub = await EpubReader.openBook(epubFileBytes);
/// // Extract values of interest.
/// String title = epub.title;
/// String author = epub.author;
/// final metadata = epub.schema.package.metadata;
/// String genres = metadata.subjects.join(', ');
/// ```
class EpubReader {
  /// Loads basics metadata.
  ///
  /// Opens the book asynchronously without reading its main content.
  /// Holds the handle to the EPUB file.
  ///
  /// Argument [bytes] should be the bytes of
  /// the epub file you have loaded with something like the [dart:io] package's
  /// [readAsBytes()].
  ///
  /// This is a fast and convenient way to get the most important information
  /// about the book, notably the [title], [author] and [authorList].
  /// Additional information is loaded in the [schema] property such as the
  /// Epub version, Publishers, Languages and more.
  static Future<EpubBookRef> openBook(FutureOr<List<int>> bytes) async {
    List<int> loadedBytes;
    if (bytes is Future) {
      loadedBytes = await bytes;
    } else {
      loadedBytes = bytes;
    }

    final epubArchive = ZipDecoder().decodeBytes(loadedBytes);

    return EpubBookRef(
      archive: epubArchive,
      schema: await SchemaReader.readSchema(epubArchive),
    );
  }

  /// Opens the book asynchronously and reads all of its content into the memory. Does not hold the handle to the EPUB file.
  static Future<EpubBook> readBook(FutureOr<List<int>> bytes) async {
    List<int> loadedBytes;
    if (bytes is Future) {
      loadedBytes = await bytes;
    } else {
      loadedBytes = bytes;
    }

    final epubBookRef = await openBook(loadedBytes);

    return EpubBook(
      schema: epubBookRef.schema,
      mainTitle: epubBookRef.title!,
      authorList: epubBookRef.authorList,
      author: epubBookRef.author,
      content: await readContent(epubBookRef.content!),
      coverImage: await epubBookRef.readCover(),
      chapters: await readChapters(await epubBookRef.getChapters()),
    );
  }

  static Future<EpubContent> readContent(EpubContentRef contentRef) async {
    final result = EpubContent(
      html: await readTextContentFiles(contentRef.html!),
      css: await readTextContentFiles(contentRef.css!),
      images: await readByteContentFiles(contentRef.images!),
      fonts: await readByteContentFiles(contentRef.fonts!),
      allFiles: <String, EpubContentFile>{},
    );

    result
      ..html!.forEach((key, value) => result.allFiles![key] = value)
      ..css!.forEach((key, value) => result.allFiles![key] = value)
      ..images!.forEach((key, value) => result.allFiles![key] = value)
      ..fonts!.forEach((key, value) => result.allFiles![key] = value);

    await Future.forEach(contentRef.allFiles!.keys, (dynamic key) async {
      if (!result.allFiles!.containsKey(key)) {
        result.allFiles![key] =
            await readByteContentFile(contentRef.allFiles![key]!);
      }
    });

    return result;
  }

  static Future<Map<String, EpubTextContentFile>> readTextContentFiles(
    Map<String, EpubTextContentFileRef> textContentFileRefs,
  ) async {
    final result = <String, EpubTextContentFile>{};

    await Future.forEach(textContentFileRefs.keys, (dynamic key) async {
      EpubContentFileRef value = textContentFileRefs[key]!;

      result[key] = EpubTextContentFile(
        fileName: value.fileName,
        contentType: value.contentType,
        contentMimeType: value.contentMimeType,
        content: await value.readContentAsText(),
      );
    });

    return result;
  }

  static Future<Map<String, EpubByteContentFile>> readByteContentFiles(
    Map<String, EpubByteContentFileRef> byteContentFileRefs,
  ) async {
    final result = <String, EpubByteContentFile>{};

    await Future.forEach(byteContentFileRefs.keys, (dynamic key) async {
      result[key] = await readByteContentFile(byteContentFileRefs[key]!);
    });

    return result;
  }

  static Future<EpubByteContentFile> readByteContentFile(
    EpubContentFileRef contentFileRef,
  ) async {
    return EpubByteContentFile(
      fileName: contentFileRef.fileName,
      contentType: contentFileRef.contentType,
      contentMimeType: contentFileRef.contentMimeType,
      content: await contentFileRef.readContentAsBytes(),
    );
  }

  static Future<List<EpubChapter>> readChapters(
      List<EpubChapterRef> chapterRefs) async {
    final result = <EpubChapter>[];

    await Future.forEach(chapterRefs, (EpubChapterRef chapterRef) async {
      result.add(
        EpubChapter(
          title: chapterRef.title,
          contentFileName: chapterRef.contentFileName,
          anchor: chapterRef.anchor,
          htmlContent: await chapterRef.readHtmlContent(),
          subChapters: await readChapters(chapterRef.subChapters!),
        ),
      );
    });

    return result;
  }
}
