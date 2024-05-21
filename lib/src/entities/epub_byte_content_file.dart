import 'package:epub_editor/src/entities/epub_content_file.dart';
import 'package:quiver/collection.dart';

class EpubByteContentFile extends EpubContentFile {
  EpubByteContentFile({
    super.fileName,
    super.contentType,
    super.contentMimeType,
    this.content,
  });

  List<int>? content;

  @override
  int get hashCode => Object.hashAll([
        contentMimeType.hashCode,
        contentType.hashCode,
        fileName.hashCode,
        ...content?.map((content) => content.hashCode) ?? [0],
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubByteContentFile)) {
      return false;
    }

    return listsEqual(content, other.content) &&
        contentMimeType == other.contentMimeType &&
        contentType == other.contentType &&
        fileName == other.fileName;
  }
}
