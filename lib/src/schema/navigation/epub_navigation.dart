import 'package:epub_editor/src/schema/navigation/epub_navigation_doc_author.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_doc_title.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_head.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_list.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_map.dart';
import 'package:epub_editor/src/schema/navigation/epub_navigation_page_list.dart';
import 'package:quiver/collection.dart';

class EpubNavigation {
  EpubNavigation({
    this.head,
    this.docTitle,
    this.docAuthors,
    this.navMap,
    this.pageList,
    this.navLists,
  });

  EpubNavigationHead? head;
  EpubNavigationDocTitle? docTitle;
  List<EpubNavigationDocAuthor>? docAuthors;
  EpubNavigationMap? navMap;
  EpubNavigationPageList? pageList;
  List<EpubNavigationList>? navLists;

  @override
  int get hashCode => Object.hashAll([
        head.hashCode,
        docTitle.hashCode,
        navMap.hashCode,
        pageList.hashCode,
        ...docAuthors?.map((author) => author.hashCode) ?? [0],
        ...navLists?.map((navList) => navList.hashCode) ?? [0]
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubNavigation)) {
      return false;
    }

    return head == other.head &&
        docTitle == other.docTitle &&
        navMap == other.navMap &&
        pageList == other.pageList &&
        listsEqual(docAuthors, other.docAuthors) &&
        listsEqual(navLists, other.navLists);
  }
}
