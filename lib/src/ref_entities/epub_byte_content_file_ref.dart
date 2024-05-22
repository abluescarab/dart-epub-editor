import 'package:epub_editor/src/ref_entities/epub_content_file_ref.dart';

class EpubByteContentFileRef extends EpubContentFileRef {
  EpubByteContentFileRef({
    required super.epubBookRef,
    super.contentType,
    super.contentMimeType,
    super.fileName,
  });

  Future<List<int>> readContent() {
    return readContentAsBytes();
  }
}
