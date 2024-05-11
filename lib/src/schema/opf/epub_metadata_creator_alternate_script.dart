import 'package:quiver/core.dart';

class EpubMetadataCreatorAlternateScript {
  EpubMetadataCreatorAlternateScript({
    this.name,
    this.dir,
    this.lang,
  });

  String? name;
  String? dir;
  String? lang;

  @override
  int get hashCode => hash3(name, dir, lang);

  @override
  bool operator ==(Object other) {
    var otherAs = other as EpubMetadataCreatorAlternateScript?;
    if (otherAs == null) return false;
    return name == otherAs.name && dir == otherAs.dir && lang == otherAs.lang;
  }
}
