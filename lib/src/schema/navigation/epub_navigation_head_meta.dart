import 'package:quiver/core.dart';

class EpubNavigationHeadMeta {
  EpubNavigationHeadMeta({
    this.name,
    this.content,
    this.scheme,
    this.charset,
  });

  String? name;
  String? content;
  String? scheme;
  String? charset;

  @override
  int get hashCode => hash4(
        name.hashCode,
        content.hashCode,
        scheme.hashCode,
        charset.hashCode,
      );

  @override
  bool operator ==(other) {
    if (!(other is EpubNavigationHeadMeta)) {
      return false;
    }

    return name == other.name &&
        content == other.content &&
        scheme == other.scheme &&
        charset == other.charset;
  }
}
