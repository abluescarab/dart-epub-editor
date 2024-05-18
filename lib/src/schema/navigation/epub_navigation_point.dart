import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_navigation_content.dart';
import 'epub_navigation_label.dart';

class EpubNavigationPoint {
  String? id;
  String? classAttribute;
  String? playOrder;
  List<EpubNavigationLabel>? navigationLabels;
  EpubNavigationContent? content;
  List<EpubNavigationPoint>? childNavigationPoints;

  @override
  int get hashCode {
    final objects = [
      id.hashCode,
      classAttribute.hashCode,
      playOrder.hashCode,
      content.hashCode,
      ...navigationLabels!.map((label) => label.hashCode),
      ...childNavigationPoints!.map((point) => point.hashCode)
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    final otherAs = other as EpubNavigationPoint?;
    if (otherAs == null) {
      return false;
    }

    if (!collections.listsEqual(navigationLabels, otherAs.navigationLabels)) {
      return false;
    }

    if (!collections.listsEqual(
        childNavigationPoints, otherAs.childNavigationPoints)) return false;

    return id == otherAs.id &&
        classAttribute == otherAs.classAttribute &&
        playOrder == otherAs.playOrder &&
        content == otherAs.content;
  }

  @override
  String toString() {
    return 'id: $id, content.source: ${content!.source}';
  }
}
