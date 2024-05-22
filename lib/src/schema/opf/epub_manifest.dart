import 'package:epub_editor/src/schema/opf/epub_manifest_item.dart';
import 'package:quiver/collection.dart';

class EpubManifest {
  EpubManifest({
    List<EpubManifestItem>? items,
  }) : this.items = items ?? [];

  List<EpubManifestItem> items;

  @override
  int get hashCode => Object.hashAll(items.map((item) => item.hashCode));

  @override
  bool operator ==(other) {
    if (!(other is EpubManifest)) {
      return false;
    }

    return listsEqual(items, other.items);
  }
}
