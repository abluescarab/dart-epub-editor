import 'package:epub_editor/src/schema/navigation/epub_navigation_content.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_label.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_page_target_type.dart';
import 'package:quiver/collection.dart';

class EpubNavigationPageTarget {
  EpubNavigationPageTarget({
    this.id,
    this.value,
    this.type,
    this.classAttribute,
    this.playOrder,
    this.content,
    this.navigationLabels,
  });

  String? id;
  String? value;
  EpubNavigationPageTargetType? type;
  String? classAttribute;
  String? playOrder;
  EpubNavigationContent? content;
  List<EpubNavigationLabel>? navigationLabels;

  @override
  int get hashCode => Object.hashAll([
        id.hashCode,
        value.hashCode,
        type.hashCode,
        classAttribute.hashCode,
        playOrder.hashCode,
        content.hashCode,
        ...navigationLabels?.map((label) => label.hashCode) ?? [0]
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubNavigationPageTarget)) {
      return false;
    }

    return id == other.id &&
        value == other.value &&
        type == other.type &&
        classAttribute == other.classAttribute &&
        playOrder == other.playOrder &&
        content == other.content &&
        listsEqual(navigationLabels, other.navigationLabels);
  }
}
