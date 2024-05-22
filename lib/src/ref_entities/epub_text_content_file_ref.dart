import 'dart:async';

import 'package:epub_editor/src/ref_entities/epub_content_file_ref.dart';

class EpubTextContentFileRef extends EpubContentFileRef {
  EpubTextContentFileRef({
    required super.epubBookRef,
    super.contentMimeType,
    super.contentType,
    super.fileName,
  });

  Future<String> readContent() async {
    return readContentAsText();
  }
}
