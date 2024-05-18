import 'package:quiver/core.dart';

class EpubNavigationHeadMeta {
  String? name;
  String? content;
  String? scheme;

  @override
  int get hashCode => hash3(name.hashCode, content.hashCode, scheme.hashCode);

  @override
  bool operator ==(other) {
    final otherAs = other as EpubNavigationHeadMeta?;
    if (otherAs == null) {
      return false;
    }

    return name == otherAs.name &&
        content == otherAs.content &&
        scheme == otherAs.scheme;
  }
}
