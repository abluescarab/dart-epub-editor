import 'package:epub_editor/epub_editor.dart';
import 'package:epub_editor/src/utils/types/epub_content_type.dart';
import 'package:quiver/core.dart';

abstract class EpubContentFile {
  EpubContentFile({
    this.fileName,
    this.contentType,
    this.contentMimeType,
  });

  String? fileName;
  EpubContentType? contentType;
  String? contentMimeType;

  @override
  int get hashCode => hash3(
        fileName.hashCode,
        contentType.hashCode,
        contentMimeType.hashCode,
      );

  @override
  bool operator ==(other) {
    if (!(other is EpubContentFile)) {
      return false;
    }

    return fileName == other.fileName &&
        contentType == other.contentType &&
        contentMimeType == other.contentMimeType;
  }
}
