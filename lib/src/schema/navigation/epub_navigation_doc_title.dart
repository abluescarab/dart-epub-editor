import 'package:quiver/collection.dart';

class EpubNavigationDocTitle {
  EpubNavigationDocTitle({
    List<String>? titles,
  }) : this.titles = titles ?? [];

  List<String> titles;

  @override
  int get hashCode => Object.hashAll(titles.map((title) => title.hashCode));

  @override
  bool operator ==(other) {
    if (!(other is EpubNavigationDocTitle)) {
      return false;
    }

    return listsEqual(titles, other.titles);
  }
}
