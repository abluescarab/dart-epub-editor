import 'package:archive/archive.dart';
import 'package:epub_editor/src/utils/types/epub_content_type.dart';
import 'package:epub_editor/src/entities/epub_schema.dart';
import 'package:epub_editor/src/readers/book_cover_reader.dart';
import 'package:epub_editor/src/readers/chapter_reader.dart';
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
    return ChapterReader.getChapters(this);
  }

  Future<EpubByteContentFileRef?> readCover() async {
    return await BookCoverReader.readBookCover(this);
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
}
