import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_point.dart';
import 'package:epub_editor/src/utils/types/epub_content_type.dart';
import 'package:epub_editor/src/entities/epub_schema.dart';
import 'package:epub_editor/src/ref_entities/epub_byte_content_file_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_chapter_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_content_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_text_content_file_ref.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_translated_string.dart';
import 'package:quiver/collection.dart';

class EpubBookRef {
  EpubBookRef({
    required this.archive,
    EpubSchema? schema,
    EpubMetadataTranslatedString? title,
    List<String?>? authors,
    EpubContentRef? content,
  }) : this.schema = schema ?? EpubSchema() {
    final metadata = this.schema.package.metadata;

    this.title =
        title ?? (metadata.titles.isNotEmpty ? metadata.titles.first : null);
    this.authors =
        authors ?? metadata.creators.map((creator) => creator.name).toList();
    this.content = content ?? _parseContentMap();
  }

  Archive archive;
  EpubSchema schema;

  /// Main title.
  EpubMetadataTranslatedString? title;
  List<String?>? authors;
  EpubContentRef? content;

  @override
  int get hashCode => Object.hashAll([
        schema.hashCode,
        title.hashCode,
        content.hashCode,
        ...authors?.map((author) => author.hashCode) ?? [0],
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubBookRef)) {
      return false;
    }

    return schema == other.schema &&
        title == other.title &&
        content == other.content &&
        listsEqual(authors, other.authors);
  }

  Future<List<EpubChapterRef>> getChapters() async {
    return _readChapters();
  }

  Future<EpubByteContentFileRef?> readCover() async {
    return await _readBookCover();
  }

  /// Reads the book cover from the [EpubManifest].
  Future<EpubByteContentFileRef?> _readBookCover() async {
    // epub v3
    final manifest = schema.package.manifest;

    if (manifest.items.isNotEmpty) {
      final coverImageItem = manifest.items
          .firstWhereOrNull((element) => element.properties == "cover-image");

      if (coverImageItem != null) {
        return content?.images[coverImageItem.href];
      }
    }

    // epub v2
    final coverMetaItem = schema.package.metadata.metaItems.firstWhereOrNull(
        (element) =>
            element.name != null && element.name!.toLowerCase() == "cover");

    if (coverMetaItem == null) {
      return null;
    }

    if (coverMetaItem.content == null ||
        coverMetaItem.content!.trim().isEmpty) {
      throw Exception(
        "Incorrect EPUB metadata: cover item content is missing.",
      );
    }

    final coverManifestItem = manifest.items.firstWhereOrNull((element) =>
        element.id != null &&
        element.id!.toLowerCase() == coverMetaItem.content!.toLowerCase());

    if (coverManifestItem == null) {
      throw Exception(
        'Incorrect EPUB manifest: item with ID = "${coverMetaItem.content}" '
        'is missing.',
      );
    }

    if (!content!.images.containsKey(coverManifestItem.href)) {
      throw Exception(
        'Incorrect EPUB manifest: item with href = "${coverManifestItem.href}" '
        'is missing.',
      );
    }

    return content!.images[coverManifestItem.href];
  }

  EpubContentRef _parseContentMap() {
    final result = EpubContentRef();

    schema.package.manifest.items.forEach((manifestItem) {
      final fileName = manifestItem.href;
      final contentMimeType = manifestItem.mediaType!;
      final contentType = ContentType.getTypeByMimeType(contentMimeType);

      if (ContentType.isText(contentType)) {
        final epubTextContentFile = EpubTextContentFileRef(
          epubBookRef: this,
          fileName: Uri.decodeFull(fileName!),
          contentMimeType: contentMimeType,
          contentType: contentType,
        );

        if (contentType == EpubContentType.xhtml11) {
          result.html[fileName] = epubTextContentFile;
        } else if (contentType == EpubContentType.css) {
          result.css[fileName] = epubTextContentFile;
        }

        result.allFiles[fileName] = epubTextContentFile;
      } else {
        final epubByteContentFile = EpubByteContentFileRef(
          epubBookRef: this,
          fileName: Uri.decodeFull(fileName!),
          contentMimeType: contentMimeType,
          contentType: contentType,
        );

        if (ContentType.isImage(contentType)) {
          result.images[fileName] = epubByteContentFile;
        } else if (ContentType.isFont(contentType)) {
          result.fonts[fileName] = epubByteContentFile;
        }

        result.allFiles[fileName] = epubByteContentFile;
      }
    });

    return result;
  }

  /// Reads all chapters from the [EpubNavigationMap].
  List<EpubChapterRef> _readChapters() {
    return _readChaptersRec(schema.navigation.navMap.points);
  }

  /// Reads chapters from the [EpubNavigationMap] recursively.
  List<EpubChapterRef> _readChaptersRec(
    List<EpubNavigationPoint> navigationPoints,
  ) {
    final result = <EpubChapterRef>[];

    for (final navPoint in navigationPoints) {
      if (navPoint.content?.source == null) {
        continue;
      }

      final source = navPoint.content!.source!;
      final anchorIndex = source.indexOf("#");

      String contentFileName;
      String? anchor;

      if (anchorIndex == -1) {
        contentFileName = source;
        anchor = null;
      } else {
        contentFileName = source.substring(0, anchorIndex);
        anchor = source.substring(0, anchorIndex + 1);
      }

      contentFileName = Uri.decodeFull(contentFileName);
      final bookContent = content;

      if (bookContent == null) {
        throw Exception("Incorrect EPUB manifest: content missing");
      }

      if (!bookContent.html.containsKey(contentFileName)) {
        throw Exception(
          'Incorrect EPUB manifest: item with href = "$contentFileName" is '
          'missing.',
        );
      }

      result.add(EpubChapterRef(
        epubTextContentFileRef: bookContent.html[contentFileName],
        contentFileName: contentFileName,
        anchor: anchor,
        title: navPoint.navigationLabels.first.text,
        subChapters: _readChaptersRec(navPoint.childNavigationPoints),
      ));
    }

    return result;
  }
}
