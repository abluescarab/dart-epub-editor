import 'package:epub_editor/epub_editor.dart';
import 'package:quiver/collection.dart';

class EpubNavigationTarget {
  EpubNavigationTarget({
    this.id,
    this.classAttribute,
    this.value,
    this.playOrder,
    this.navigationLabels,
    this.content,
  });

  String? id;
  String? classAttribute;
  String? value;
  String? playOrder;
  List<EpubNavigationLabel>? navigationLabels;
  EpubNavigationContent? content;

  @override
  int get hashCode => Object.hashAll([
        id.hashCode,
        classAttribute.hashCode,
        value.hashCode,
        playOrder.hashCode,
        content.hashCode,
        ...navigationLabels!.map((label) => label.hashCode)
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubNavigationTarget)) {
      return false;
    }

    return id == other.id &&
        classAttribute == other.classAttribute &&
        value == other.value &&
        playOrder == other.playOrder &&
        content == other.content &&
        listsEqual(navigationLabels, other.navigationLabels);
  }
}
