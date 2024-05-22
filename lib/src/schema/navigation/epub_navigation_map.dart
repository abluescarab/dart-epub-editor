import 'package:epub_editor/src/schema/navigation/epub_navigation_point.dart';
import 'package:quiver/collection.dart';

class EpubNavigationMap {
  EpubNavigationMap({required this.points});

  List<EpubNavigationPoint> points;

  @override
  int get hashCode => Object.hashAll(points.map((point) => point.hashCode));

  @override
  bool operator ==(other) {
    if (!(other is EpubNavigationMap)) {
      return false;
    }

    return listsEqual(points, other.points);
  }
}
