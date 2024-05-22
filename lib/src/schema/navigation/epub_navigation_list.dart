import 'package:epub_editor/src/schema/navigation/epub_navigation_label.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_target.dart';
import 'package:quiver/collection.dart';

class EpubNavigationList {
  EpubNavigationList({
    List<EpubNavigationLabel>? navigationLabels,
    List<EpubNavigationTarget>? navigationTargets,
    this.id,
    this.classAttribute,
  })  : this.navigationLabels = navigationLabels ?? [],
        this.navigationTargets = navigationTargets ?? [];

  List<EpubNavigationLabel> navigationLabels;
  List<EpubNavigationTarget> navigationTargets;

  String? id;
  String? classAttribute;

  @override
  int get hashCode => Object.hashAll([
        id.hashCode,
        classAttribute.hashCode,
        ...navigationLabels.map((label) => label.hashCode),
        ...navigationTargets.map((target) => target.hashCode)
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubNavigationList)) {
      return false;
    }

    return id == other.id &&
        classAttribute == other.classAttribute &&
        listsEqual(navigationLabels, other.navigationLabels) &&
        listsEqual(navigationTargets, other.navigationTargets);
  }
}
