import 'package:epub_editor/epub_editor.dart';
import 'package:epub_editor/src/utils/types/epub_content_type.dart';
import 'package:quiver/core.dart';

abstract class EpubContentFile {
  EpubContentFile({
    this.contentType,
    this.contentMimeType,
    this.fileName,
  });

  EpubContentType? contentType;
  String? contentMimeType;
  String? fileName;

  @override
  int get hashCode => hash3(
        contentMimeType.hashCode,
        contentType.hashCode,
        fileName.hashCode,
      );

  @override
  bool operator ==(other) {
    if (!(other is EpubContentFile)) {
      return false;
    }

    return contentMimeType == other.contentMimeType &&
        contentType == other.contentType &&
        fileName == other.fileName;
  }
}
