import 'package:quiver/core.dart';

class EpubMetadataAlternateScript {
  EpubMetadataAlternateScript({
    this.value,
    this.dir,
    this.lang,
  });

  String? value;
  String? dir;
  String? lang;

  @override
  int get hashCode => hash3(value.hashCode, dir.hashCode, lang.hashCode);

  @override
  bool operator ==(Object other) {
    if (!(other is EpubMetadataAlternateScript)) {
      return false;
    }

    return value == other.value && dir == other.dir && lang == other.lang;
  }
}
