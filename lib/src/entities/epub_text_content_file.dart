import 'package:epub_editor/epub_editor.dart';
import 'package:epub_editor/src/entities/epub_content_file.dart';
import 'package:quiver/core.dart';

class EpubTextContentFile extends EpubContentFile {
  EpubTextContentFile({
    super.contentType,
    super.contentMimeType,
    super.fileName,
    required this.content,
  });

  String content;

  @override
  int get hashCode => hash4(
        contentMimeType.hashCode,
        contentType.hashCode,
        fileName.hashCode,
        content.hashCode,
      );

  @override
  bool operator ==(other) {
    if (!(other is EpubTextContentFile)) {
      return false;
    }

    return contentMimeType == other.contentMimeType &&
        contentType == other.contentType &&
        fileName == other.fileName &&
        content == other.content;
  }
}
