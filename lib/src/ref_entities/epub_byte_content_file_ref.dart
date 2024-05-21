import 'package:epub_editor/src/ref_entities/epub_content_file_ref.dart';

class EpubByteContentFileRef extends EpubContentFileRef {
  EpubByteContentFileRef({
    required super.epubBookRef,
    super.fileName,
    super.contentType,
    super.contentMimeType,
  });

  Future<List<int>> readContent() {
    return readContentAsBytes();
  }
}
