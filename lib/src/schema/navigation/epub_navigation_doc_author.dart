import 'package:quiver/collection.dart';

class EpubNavigationDocAuthor {
  EpubNavigationDocAuthor({
    List<String>? authors,
  }) : this.authors = authors ?? [];

  List<String> authors;

  @override
  int get hashCode => Object.hashAll(authors.map((author) => author.hashCode));

  @override
  bool operator ==(other) {
    if (!(other is EpubNavigationDocAuthor)) {
      return false;
    }

    return listsEqual(authors, other.authors);
  }
}
