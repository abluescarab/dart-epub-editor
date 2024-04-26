import '../entities/epub_content_type.dart';
import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_byte_content_file_ref.dart';
import '../ref_entities/epub_content_file_ref.dart';
import '../ref_entities/epub_content_ref.dart';
import '../ref_entities/epub_text_content_file_ref.dart';
import '../schema/opf/epub_manifest_item.dart';

class ContentReader {
  static EpubContentRef parseContentMap(EpubBookRef bookRef) {
    var result = EpubContentRef();
    result.html = <String, EpubTextContentFileRef>{};
    result.css = <String, EpubTextContentFileRef>{};
    result.images = <String, EpubByteContentFileRef>{};
    result.fonts = <String, EpubByteContentFileRef>{};
    result.allFiles = <String, EpubContentFileRef>{};

    bookRef.schema!.package!.manifest!.items!
        .forEach((EpubManifestItem manifestItem) {
      var fileName = manifestItem.href;
      var contentMimeType = manifestItem.mediaType!;
      var contentType = getContentTypeByContentMimeType(contentMimeType);
      switch (contentType) {
        case EpubContentType.xhtml_1_1:
        case EpubContentType.css:
        case EpubContentType.oeb1_document:
        case EpubContentType.oeb1_css:
        case EpubContentType.xml:
        case EpubContentType.dtbook:
        case EpubContentType.dtbook_ncx:
          var epubTextContentFile = EpubTextContentFileRef(bookRef);
          {
            epubTextContentFile.fileName = Uri.decodeFull(fileName!);
            epubTextContentFile.contentMimeType = contentMimeType;
            epubTextContentFile.contentType = contentType;
          }
          ;
          switch (contentType) {
            case EpubContentType.xhtml_1_1:
              result.html![fileName] = epubTextContentFile;
              break;
            case EpubContentType.css:
              result.css![fileName] = epubTextContentFile;
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
          result.allFiles![fileName] = epubTextContentFile;
          break;
        default:
          var epubByteContentFile = EpubByteContentFileRef(bookRef);
          {
            epubByteContentFile.fileName = Uri.decodeFull(fileName!);
            epubByteContentFile.contentMimeType = contentMimeType;
            epubByteContentFile.contentType = contentType;
          }
          ;
          switch (contentType) {
            case EpubContentType.image_gif:
            case EpubContentType.image_jpeg:
            case EpubContentType.image_png:
            case EpubContentType.image_svg:
            case EpubContentType.image_bmp:
              result.images![fileName] = epubByteContentFile;
              break;
            case EpubContentType.font_truetype:
            case EpubContentType.font_opentype:
              result.fonts![fileName] = epubByteContentFile;
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
          result.allFiles![fileName] = epubByteContentFile;
          break;
      }
    });
    return result;
  }

  static EpubContentType getContentTypeByContentMimeType(
      String contentMimeType) {
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
}
