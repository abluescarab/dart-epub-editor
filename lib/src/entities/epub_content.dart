import 'package:epub_editor/src/entities/epub_byte_content_file.dart';
import 'package:epub_editor/src/entities/epub_content_file.dart';
import 'package:epub_editor/src/entities/epub_text_content_file.dart';
import 'package:quiver/collection.dart';

class EpubContent {
  EpubContent({
    this.html,
    this.css,
    this.images,
    this.fonts,
    this.allFiles,
  });

  Map<String, EpubTextContentFile>? html = {};
  Map<String, EpubTextContentFile>? css = {};
  Map<String, EpubByteContentFile>? images = {};
  Map<String, EpubByteContentFile>? fonts = {};
  Map<String, EpubContentFile>? allFiles = {};

  @override
  int get hashCode => Object.hashAll([
        ...html!.keys.map((key) => key.hashCode),
        ...html!.values.map((value) => value.hashCode),
        ...css!.keys.map((key) => key.hashCode),
        ...css!.values.map((value) => value.hashCode),
        ...images!.keys.map((key) => key.hashCode),
        ...images!.values.map((value) => value.hashCode),
        ...fonts!.keys.map((key) => key.hashCode),
        ...fonts!.values.map((value) => value.hashCode),
        ...allFiles!.keys.map((key) => key.hashCode),
        ...allFiles!.values.map((value) => value.hashCode),
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubContent)) {
      return false;
    }

    return mapsEqual(html, other.html) &&
        mapsEqual(css, other.css) &&
        mapsEqual(images, other.images) &&
        mapsEqual(fonts, other.fonts) &&
        mapsEqual(allFiles, other.allFiles);
  }
}
