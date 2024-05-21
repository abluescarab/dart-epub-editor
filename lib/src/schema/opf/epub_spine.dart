import 'package:epub_editor/src/schema/opf/epub_spine_item_ref.dart';
import 'package:quiver/collection.dart';

class EpubSpine {
  EpubSpine({
    this.tableOfContents,
    this.items,
    this.ltr,
  });

  String? tableOfContents;
  List<EpubSpineItemRef>? items;
  bool? ltr;

  @override
  int get hashCode => Object.hashAll([
        tableOfContents.hashCode,
        ltr.hashCode,
        ...items!.map((item) => item.hashCode)
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubSpine)) {
      return false;
    }

    return tableOfContents == other.tableOfContents &&
        listsEqual(items, other.items) &&
        ltr == other.ltr;
  }
}
