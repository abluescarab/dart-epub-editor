import 'package:epub_editor/src/schema/navigation/epub_navigation_page_target.dart';
import 'package:quiver/collection.dart';

class EpubNavigationPageList {
  EpubNavigationPageList({
    this.targets,
  });

  List<EpubNavigationPageTarget>? targets;

  @override
  int get hashCode =>
      Object.hashAll(targets?.map((target) => target.hashCode) ?? [0]);

  @override
  bool operator ==(other) {
    if (!(other is EpubNavigationPageList)) {
      return false;
    }

    return listsEqual(targets, other.targets);
  }
}
