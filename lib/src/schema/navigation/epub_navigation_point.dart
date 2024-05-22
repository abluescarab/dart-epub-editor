import 'package:epub_editor/epub_editor.dart';
import 'package:quiver/collection.dart';

class EpubNavigationPoint {
  EpubNavigationPoint({
    List<EpubNavigationPoint>? childNavigationPoints,
    List<EpubNavigationLabel>? navigationLabels,
    this.id,
    this.classAttribute,
    this.playOrder,
    this.content,
  })  : this.childNavigationPoints = childNavigationPoints ?? [],
        this.navigationLabels = navigationLabels ?? [];

  List<EpubNavigationPoint> childNavigationPoints;
  List<EpubNavigationLabel> navigationLabels;

  String? id;
  String? classAttribute;
  String? playOrder;
  EpubNavigationContent? content;

  @override
  int get hashCode => Object.hashAll([
        id.hashCode,
        classAttribute.hashCode,
        playOrder.hashCode,
        content.hashCode,
        ...navigationLabels.map((label) => label.hashCode),
        ...childNavigationPoints.map((point) => point.hashCode)
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubNavigationPoint)) {
      return false;
    }

    return id == other.id &&
        classAttribute == other.classAttribute &&
        playOrder == other.playOrder &&
        listsEqual(navigationLabels, other.navigationLabels) &&
        content == other.content &&
        listsEqual(childNavigationPoints, other.childNavigationPoints);
  }

  @override
  String toString() {
    return 'id: $id, content.source: ${content?.source}';
  }
}
