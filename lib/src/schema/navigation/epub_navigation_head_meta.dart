import 'package:quiver/core.dart';

class EpubNavigationHeadMeta {
  EpubNavigationHeadMeta({
    this.name,
    this.content,
    this.scheme,
  });

  String? name;
  String? content;
  String? scheme;

  @override
  int get hashCode => hash3(name.hashCode, content.hashCode, scheme.hashCode);

  @override
  bool operator ==(other) {
    if (!(other is EpubNavigationHeadMeta)) {
      return false;
    }

    return name == other.name &&
        content == other.content &&
        scheme == other.scheme;
  }
}
