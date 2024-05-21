import 'package:epub_editor/src/schema/navigation/epub_navigation_label.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_target.dart';
import 'package:quiver/collection.dart';

class EpubNavigationList {
  EpubNavigationList({
    this.id,
    this.classAttribute,
    this.navigationLabels,
    this.navigationTargets,
  });

  String? id;
  String? classAttribute;
  List<EpubNavigationLabel>? navigationLabels;
  List<EpubNavigationTarget>? navigationTargets;

  @override
  int get hashCode => Object.hashAll([
        id.hashCode,
        classAttribute.hashCode,
        ...navigationLabels?.map((label) => label.hashCode) ?? [0],
        ...navigationTargets?.map((target) => target.hashCode) ?? [0]
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
