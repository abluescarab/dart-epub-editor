import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

class EpubNavigationDocTitle {
  List<String>? titles;

  EpubNavigationDocTitle() {
    titles = <String>[];
  }

  @override
  int get hashCode {
    final objects = [...titles!.map((title) => title.hashCode)];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    final otherAs = other as EpubNavigationDocTitle?;
    if (otherAs == null) return false;

    return collections.listsEqual(titles, otherAs.titles);
  }
}
