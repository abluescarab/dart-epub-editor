enum EpubContentType {
  xhtml11,
  dtbook,
  dtbookNcx,
  oeb1Document,
  xml,
  css,
  oeb1Css,
  imageGif,
  imageJpeg,
  imagePng,
  imageSvg,
  imageBmp,
  fontTrueType,
  fontOpenType,
  other
}

class ContentType {
  static const _mimeTypes = <String, EpubContentType>{
    'application/xhtml+xml': EpubContentType.xhtml11,
    'text/html': EpubContentType.xhtml11,
    'application/x-dtbook+xml': EpubContentType.dtbook,
    'application/x-dtbncx+xml': EpubContentType.dtbookNcx,
    'text/x-oeb1-document': EpubContentType.oeb1Document,
    'application/xml': EpubContentType.xml,
    'text/css': EpubContentType.css,
    'text/x-oeb1-css': EpubContentType.oeb1Css,
    'image/gif': EpubContentType.imageGif,
    'image/jpeg': EpubContentType.imageJpeg,
    'image/png': EpubContentType.imagePng,
    'image/svg+xml': EpubContentType.imageSvg,
    'image/bmp': EpubContentType.imageBmp,
    'font/truetype': EpubContentType.fontTrueType,
    'font/opentype': EpubContentType.fontOpenType,
    'application/vnd.ms-opentype': EpubContentType.fontOpenType,
  };

  static EpubContentType getTypeByMimeType(String contentMimeType) {
    if (_mimeTypes.containsKey(contentMimeType.toLowerCase())) {
      return _mimeTypes[contentMimeType]!;
    }

    return EpubContentType.other;
  }

  static bool isText(EpubContentType type) {
    return type == EpubContentType.xhtml11 ||
        type == EpubContentType.css ||
        type == EpubContentType.oeb1Document ||
        type == EpubContentType.oeb1Css ||
        type == EpubContentType.xml ||
        type == EpubContentType.dtbook ||
        type == EpubContentType.dtbookNcx;
  }

  static bool isImage(EpubContentType type) {
    return type == EpubContentType.imageGif ||
        type == EpubContentType.imageJpeg ||
        type == EpubContentType.imagePng ||
        type == EpubContentType.imageSvg ||
        type == EpubContentType.imageBmp;
  }

  static bool isFont(EpubContentType type) {
    return type == EpubContentType.fontOpenType ||
        type == EpubContentType.fontTrueType;
  }
}
