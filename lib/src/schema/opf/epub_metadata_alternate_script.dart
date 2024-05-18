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
  int get hashCode => hash3(value, dir, lang);

  @override
  bool operator ==(Object other) {
    final otherAs = other as EpubMetadataAlternateScript?;
    if (otherAs == null) return false;
    return value == otherAs.value && dir == otherAs.dir && lang == otherAs.lang;
  }
}
