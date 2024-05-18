import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_navigation_content.dart';
import 'epub_navigation_label.dart';
import 'epub_navigation_page_target_type.dart';

class EpubNavigationPageTarget {
  String? id;
  String? value;
  EpubNavigationPageTargetType? type;
  String? classAttribute;
  String? playOrder;
  List<EpubNavigationLabel>? navigationLabels;
  EpubNavigationContent? content;

  @override
  int get hashCode {
    final objects = [
      id.hashCode,
      value.hashCode,
      type.hashCode,
      classAttribute.hashCode,
      playOrder.hashCode,
      content.hashCode,
      ...navigationLabels?.map((label) => label.hashCode) ?? [0]
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    final otherAs = other as EpubNavigationPageTarget?;
    if (otherAs == null) {
      return false;
    }

    if (!(id == otherAs.id &&
        value == otherAs.value &&
        type == otherAs.type &&
        classAttribute == otherAs.classAttribute &&
        playOrder == otherAs.playOrder &&
        content == otherAs.content)) {
      return false;
    }

    return collections.listsEqual(navigationLabels, otherAs.navigationLabels);
  }
}
