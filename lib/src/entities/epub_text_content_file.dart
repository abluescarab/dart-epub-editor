import 'package:epub_editor/epub_editor.dart';
import 'package:epub_editor/src/entities/epub_content_file.dart';
import 'package:quiver/core.dart';

class EpubTextContentFile extends EpubContentFile {
  EpubTextContentFile({
    super.fileName,
    super.contentType,
    super.contentMimeType,
    this.content,
  });

  String? content;

  @override
  int get hashCode => hash4(
        content.hashCode,
        contentMimeType.hashCode,
        contentType.hashCode,
        fileName.hashCode,
      );

  @override
  bool operator ==(other) {
    if (!(other is EpubTextContentFile)) {
      return false;
    }

    return content == other.content &&
        contentMimeType == other.contentMimeType &&
        contentType == other.contentType &&
        fileName == other.fileName;
  }
}
