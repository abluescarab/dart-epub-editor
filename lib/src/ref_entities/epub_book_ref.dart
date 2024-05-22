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
        archive.hashCode,
        title.hashCode,
        schema.hashCode,
        content.hashCode,
        ...authors?.map((author) => author.hashCode) ?? [0],
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubBookRef)) {
      return false;
    }

    return archive == other.archive &&
        title == other.title &&
        schema == other.schema &&
        content == other.content &&
        listsEqual(authors, other.authors);
  }

  Future<List<EpubChapterRef>> getChapters() async {
    return ChapterReader.getChapters(this);
  }

  Future<EpubByteContentFileRef?> readCover() async {
    return await BookCoverReader.readBookCover(this);
  }

  static EpubContentType _getContentTypeByContentMimeType(
    String contentMimeType,
  ) {
    switch (contentMimeType.toLowerCase()) {
      case 'application/xhtml+xml':
      case 'text/html':
        return EpubContentType.xhtml_1_1;
      case 'application/x-dtbook+xml':
        return EpubContentType.dtbook;
      case 'application/x-dtbncx+xml':
        return EpubContentType.dtbook_ncx;
      case 'text/x-oeb1-document':
        return EpubContentType.oeb1_document;
      case 'application/xml':
        return EpubContentType.xml;
      case 'text/css':
        return EpubContentType.css;
      case 'text/x-oeb1-css':
        return EpubContentType.oeb1_css;
      case 'image/gif':
        return EpubContentType.image_gif;
      case 'image/jpeg':
        return EpubContentType.image_jpeg;
      case 'image/png':
        return EpubContentType.image_png;
      case 'image/svg+xml':
        return EpubContentType.image_svg;
      case 'image/bmp':
        return EpubContentType.image_bmp;
      case 'font/truetype':
        return EpubContentType.font_truetype;
      case 'font/opentype':
        return EpubContentType.font_opentype;
      case 'application/vnd.ms-opentype':
        return EpubContentType.font_opentype;
      default:
        return EpubContentType.other;
    }
  }

  EpubContentRef _parseContentMap() {
    final result = EpubContentRef(
      html: <String, EpubTextContentFileRef>{},
      css: <String, EpubTextContentFileRef>{},
      images: <String, EpubByteContentFileRef>{},
      fonts: <String, EpubByteContentFileRef>{},
      allFiles: <String, EpubTextContentFileRef>{},
    );

    schema.package.manifest.items.forEach((manifestItem) {
      final fileName = manifestItem.href;
      final contentMimeType = manifestItem.mediaType!;
      final contentType = _getContentTypeByContentMimeType(contentMimeType);

      switch (contentType) {
        case EpubContentType.xhtml_1_1:
        case EpubContentType.css:
        case EpubContentType.oeb1_document:
        case EpubContentType.oeb1_css:
        case EpubContentType.xml:
        case EpubContentType.dtbook:
        case EpubContentType.dtbook_ncx:
          final epubTextContentFile = EpubTextContentFileRef(
            epubBookRef: this,
            fileName: Uri.decodeFull(fileName!),
            contentMimeType: contentMimeType,
            contentType: contentType,
          );

          switch (contentType) {
            case EpubContentType.xhtml_1_1:
              result.html[fileName] = epubTextContentFile;
              break;
            case EpubContentType.css:
              result.css[fileName] = epubTextContentFile;
              break;
            case EpubContentType.dtbook:
            case EpubContentType.dtbook_ncx:
            case EpubContentType.oeb1_document:
            case EpubContentType.xml:
            case EpubContentType.oeb1_css:
            case EpubContentType.image_gif:
            case EpubContentType.image_jpeg:
            case EpubContentType.image_png:
            case EpubContentType.image_svg:
            case EpubContentType.image_bmp:
            case EpubContentType.font_truetype:
            case EpubContentType.font_opentype:
            case EpubContentType.other:
              break;
          }

          result.allFiles[fileName] = epubTextContentFile;
          break;
        default:
          final epubByteContentFile = EpubByteContentFileRef(
            epubBookRef: this,
            fileName: Uri.decodeFull(fileName!),
            contentMimeType: contentMimeType,
            contentType: contentType,
          );

          switch (contentType) {
            case EpubContentType.image_gif:
            case EpubContentType.image_jpeg:
            case EpubContentType.image_png:
            case EpubContentType.image_svg:
            case EpubContentType.image_bmp:
              result.images[fileName] = epubByteContentFile;
              break;
            case EpubContentType.font_truetype:
            case EpubContentType.font_opentype:
              result.fonts[fileName] = epubByteContentFile;
              break;
            case EpubContentType.css:
            case EpubContentType.xhtml_1_1:
            case EpubContentType.dtbook:
            case EpubContentType.dtbook_ncx:
            case EpubContentType.oeb1_document:
            case EpubContentType.xml:
            case EpubContentType.oeb1_css:
            case EpubContentType.other:
              break;
          }

          result.allFiles[fileName] = epubByteContentFile;
          break;
      }
    });

    return result;
  }
}
