class EpubNavigationHeadMeta {
  /* TODO: change metadata elements to maps? i.e.
      attributes = {
        'charset': value,
        'content': value,
        'http-equiv': value,
        ...
      }
  */
  EpubNavigationHeadMeta({
    this.charset,
    this.content,
    this.httpEquiv,
    this.media,
    this.name,
    this.scheme,
  });

  String? charset;
  String? content;
  String? httpEquiv;
  String? media;
  String? name;
  String? scheme;

  @override
  int get hashCode => Object.hashAll([
        charset.hashCode,
        content.hashCode,
        httpEquiv.hashCode,
        media.hashCode,
        name.hashCode,
        scheme.hashCode,
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubNavigationHeadMeta)) {
      return false;
    }

    return charset == other.charset &&
        content == other.content &&
        httpEquiv == other.httpEquiv &&
        media == other.media &&
        name == other.name &&
        scheme == other.scheme;
  }
}
