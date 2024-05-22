import 'package:epub_editor/src/schema/opf/epub_guide_reference.dart';
import 'package:quiver/collection.dart';

class EpubGuide {
  EpubGuide({
    List<EpubGuideReference>? items,
  }) : this.items = items ?? [];

  List<EpubGuideReference> items;

  @override
  int get hashCode => Object.hashAll(items.map((item) => item.hashCode));

  @override
  bool operator ==(other) {
    if (!(other is EpubGuide)) {
      return false;
    }

    return listsEqual(items, other.items);
  }
}
