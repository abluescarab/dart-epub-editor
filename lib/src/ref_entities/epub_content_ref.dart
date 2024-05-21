import 'package:epub_editor/src/ref_entities/epub_byte_content_file_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_content_file_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_text_content_file_ref.dart';
import 'package:quiver/collection.dart';

class EpubContentRef {
  EpubContentRef({
    this.html,
    this.css,
    this.images,
    this.fonts,
    this.allFiles,
  });

  Map<String, EpubTextContentFileRef>? html = {};
  Map<String, EpubTextContentFileRef>? css = {};
  Map<String, EpubByteContentFileRef>? images = {};
  Map<String, EpubByteContentFileRef>? fonts = {};
  Map<String, EpubContentFileRef>? allFiles = {};

  @override
  int get hashCode {
    return Object.hashAll([
      ...html!.keys.map((key) => key.hashCode),
      ...html!.values.map((value) => value.hashCode),
      ...css!.keys.map((key) => key.hashCode),
      ...css!.values.map((value) => value.hashCode),
      ...images!.keys.map((key) => key.hashCode),
      ...images!.values.map((value) => value.hashCode),
      ...fonts!.keys.map((key) => key.hashCode),
      ...fonts!.values.map((value) => value.hashCode),
      ...allFiles!.keys.map((key) => key.hashCode),
      ...allFiles!.values.map((value) => value.hashCode)
    ]);
  }

  @override
  bool operator ==(other) {
    if (!(other is EpubContentRef)) {
      return false;
    }

    return mapsEqual(html, other.html) &&
        mapsEqual(css, other.css) &&
        mapsEqual(images, other.images) &&
        mapsEqual(fonts, other.fonts) &&
        mapsEqual(allFiles, other.allFiles);
  }
}
