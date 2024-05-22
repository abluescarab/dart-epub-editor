class EpubManifestItem {
  EpubManifestItem({
    this.id,
    this.href,
    this.mediaType,
    this.mediaOverlay,
    this.requiredNamespace,
    this.requiredModules,
    this.fallback,
    this.fallbackStyle,
    this.properties,
  });

  String? id;
  String? href;
  String? mediaType;
  String? mediaOverlay;
  String? requiredNamespace;
  String? requiredModules;
  String? fallback;
  String? fallbackStyle;
  String? properties;

  @override
  int get hashCode => Object.hashAll([
        id.hashCode,
        href.hashCode,
        mediaType.hashCode,
        mediaOverlay.hashCode,
        requiredNamespace.hashCode,
        requiredModules.hashCode,
        fallback.hashCode,
        fallbackStyle.hashCode,
        properties.hashCode
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubManifestItem)) {
      return false;
    }

    return id == other.id &&
        href == other.href &&
        mediaType == other.mediaType &&
        mediaOverlay == other.mediaOverlay &&
        requiredNamespace == other.requiredNamespace &&
        requiredModules == other.requiredModules &&
        fallback == other.fallback &&
        fallbackStyle == other.fallbackStyle &&
        properties == other.properties;
  }

  @override
  String toString() {
    return 'Id: $id, Href = $href, MediaType = $mediaType, Properties = '
        '$properties, MediaOverlay = $mediaOverlay';
  }
}
