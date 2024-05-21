import 'package:epub_editor/src/schema/navigation/epub_navigation_head_meta.dart';
import 'package:quiver/collection.dart';

class EpubNavigationHead {
  EpubNavigationHead({
    this.metadata,
  }) {
    metadata ??= [];
  }

  List<EpubNavigationHeadMeta>? metadata;

  @override
  int get hashCode => Object.hashAll(metadata!.map((meta) => meta.hashCode));

  @override
  bool operator ==(other) {
    if (!(other is EpubNavigationHead)) {
      return false;
    }

    return listsEqual(metadata, other.metadata);
  }
}
