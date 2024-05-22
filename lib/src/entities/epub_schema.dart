import 'package:epub_editor/epub_editor.dart';
import 'package:quiver/core.dart';

class EpubSchema {
  EpubSchema({
    EpubPackage? package,
    EpubNavigation? navigation,
    this.contentDirectoryPath,
  })  : this.package = package ?? EpubPackage(),
        this.navigation = navigation ?? EpubNavigation();

  EpubPackage package;
  EpubNavigation navigation;

  String? contentDirectoryPath;

  @override
  int get hashCode => hash3(
        package.hashCode,
        navigation.hashCode,
        contentDirectoryPath.hashCode,
      );

  @override
  bool operator ==(other) {
    if (!(other is EpubSchema)) {
      return false;
    }

    return package == other.package &&
        navigation == other.navigation &&
        contentDirectoryPath == other.contentDirectoryPath;
  }
}
