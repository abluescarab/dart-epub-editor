import 'dart:async';
import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:epub_editor/src/entities/epub_book.dart';
import 'package:epub_editor/src/entities/epub_byte_content_file.dart';
import 'package:epub_editor/src/entities/epub_chapter.dart';
import 'package:epub_editor/src/entities/epub_content.dart';
import 'package:epub_editor/src/entities/epub_schema.dart';
import 'package:epub_editor/src/entities/epub_text_content_file.dart';
import 'package:epub_editor/src/readers/navigation_reader.dart';
import 'package:epub_editor/src/readers/package_reader.dart';
import 'package:epub_editor/src/ref_entities/epub_book_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_byte_content_file_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_chapter_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_content_file_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_content_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_text_content_file_ref.dart';
import 'package:epub_editor/src/utils/zip_path_utils.dart';
import 'package:xml/xml.dart';

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
  /// about the book, notably the [title] and [authors].
  /// Additional information is loaded in the [schema] property such as the
  /// Epub version, Publishers, Languages and more.
  static Future<EpubBookRef> openBook(List<int> bytes) async {
    final epubArchive = ZipDecoder().decodeBytes(bytes);

    return EpubBookRef(
      archive: epubArchive,
      schema: await _readSchema(epubArchive),
    );
  }

  /// Opens the book asynchronously and reads all of its content into the
  /// memory. Does not hold the handle to the EPUB file.
  static Future<EpubBook> readBook(List<int> bytes) async {
    final epubBookRef = await openBook(bytes);

    return EpubBook(
      schema: epubBookRef.schema,
      content: await _readContent(epubBookRef.content!),
      chapters: await readChapters(await epubBookRef.getChapters()),
      mainTitle: epubBookRef.title,
      authors: epubBookRef.authors,
      coverImage: await epubBookRef.readCover(),
    );
  }

  static Future<EpubContent> _readContent(EpubContentRef contentRef) async {
    final result = EpubContent(
      html: await _readTextContentFiles(contentRef.html),
      css: await _readTextContentFiles(contentRef.css),
      images: await _readByteContentFiles(contentRef.images),
      fonts: await _readByteContentFiles(contentRef.fonts),
    );

    result
      ..html.forEach((key, value) => result.allFiles[key] = value)
      ..css.forEach((key, value) => result.allFiles[key] = value)
      ..images.forEach((key, value) => result.allFiles[key] = value)
      ..fonts.forEach((key, value) => result.allFiles[key] = value);

    contentRef.allFiles.keys.forEach((key) async {
      if (!result.allFiles.containsKey(key)) {
        result.allFiles[key] = await _readByteContentFile(
          contentRef.allFiles[key]!,
        );
      }
    });

    return result;
  }

  static Future<Map<String, EpubTextContentFile>> _readTextContentFiles(
    Map<String, EpubTextContentFileRef> textContentFileRefs,
  ) async {
    final result = <String, EpubTextContentFile>{};

    textContentFileRefs.keys.forEach((key) async {
      final value = textContentFileRefs[key]!;

      result[key] = EpubTextContentFile(
        fileName: value.fileName,
        contentType: value.contentType,
        contentMimeType: value.contentMimeType,
        content: await value.readContentAsText(),
      );
    });

    return result;
  }

  static Future<Map<String, EpubByteContentFile>> _readByteContentFiles(
    Map<String, EpubByteContentFileRef> byteContentFileRefs,
  ) async {
    final result = <String, EpubByteContentFile>{};

    byteContentFileRefs.keys.forEach((key) async {
      result[key] = await _readByteContentFile(byteContentFileRefs[key]!);
    });

    return result;
  }

  static Future<EpubByteContentFile> _readByteContentFile(
    EpubContentFileRef contentFileRef,
  ) async =>
      EpubByteContentFile(
        fileName: contentFileRef.fileName,
        contentType: contentFileRef.contentType,
        contentMimeType: contentFileRef.contentMimeType,
        content: await contentFileRef.readContentAsBytes(),
      );

  static Future<List<EpubChapter>> readChapters(
    List<EpubChapterRef> chapterRefs,
  ) async {
    final result = <EpubChapter>[];

    chapterRefs.forEach(
      (chapterRef) async => result.add(
        EpubChapter(
          title: chapterRef.title,
          contentFileName: chapterRef.contentFileName,
          anchor: chapterRef.anchor,
          htmlContent: await chapterRef.readHtmlContent(),
          subChapters: await readChapters(chapterRef.subChapters),
        ),
      ),
    );

    return result;
  }

  /// Reads the path for the ePub root file in the [archive].
  static Future<String> _readRootFilePath(Archive archive) async {
    const containerFilePath = "META-INF/container.xml";
    final containerFileEntry = archive.files
        .firstWhereOrNull((element) => element.name == containerFilePath);

    if (containerFileEntry == null) {
      throw Exception(
        "EPUB parsing error: $containerFilePath file not found in archive.",
      );
    }

    final packageElement =
        XmlDocument.parse(utf8.decode(containerFileEntry.content))
            .findAllElements(
              "container",
              namespace: "urn:oasis:names:tc:opendocument:xmlns:container",
            )
            .firstOrNull;

    if (packageElement == null) {
      throw Exception("EPUB parsing error: invalid epub container");
    }

    final rootFileElement = packageElement.descendants.firstWhereOrNull(
      (element) => (element is XmlElement) && "rootfile" == element.name.local,
    ) as XmlElement;

    final rootFilePath = rootFileElement.getAttribute("full-path");

    if (rootFilePath == null) {
      throw Exception(
        "EPUB parsing error: root file not found in $containerFilePath",
      );
    }

    return rootFilePath;
  }

  /// Reads the [EpubSchema] from a given [archive].
  static Future<EpubSchema> _readSchema(Archive archive) async {
    final rootFilePath = await _readRootFilePath(archive);
    final contentDirectoryPath = ZipPathUtils.getDirectoryPath(rootFilePath);
    final package = await PackageReader.readPackage(archive, rootFilePath);
    final navigation = await NavigationReader.readNavigation(
      archive,
      contentDirectoryPath,
      package,
    );

    return EpubSchema(
      package: package,
      navigation: navigation,
      contentDirectoryPath: contentDirectoryPath,
    );
  }
}
