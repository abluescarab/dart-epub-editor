import 'dart:async';

import 'package:epub_editor/src/ref_entities/epub_content_file_ref.dart';

class EpubTextContentFileRef extends EpubContentFileRef {
  EpubTextContentFileRef({
    required super.epubBookRef,
    super.fileName,
    super.contentType,
    super.contentMimeType,
  });

  Future<String> ReadContentAsync() async {
    return readContentAsText();
  }
}
