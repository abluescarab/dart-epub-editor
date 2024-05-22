import 'package:archive/archive.dart';
import 'package:epub_editor/src/entities/epub_schema.dart';
import 'package:epub_editor/src/readers/navigation_reader.dart';
import 'package:epub_editor/src/readers/package_reader.dart';
import 'package:epub_editor/src/readers/root_file_path_reader.dart';
import 'package:epub_editor/src/utils/zip_path_utils.dart';

class SchemaReader {
  static Future<EpubSchema> readSchema(Archive epubArchive) async {
    final rootFilePath =
        (await RootFilePathReader.getRootFilePath(epubArchive))!;
    final contentDirectoryPath = ZipPathUtils.getDirectoryPath(rootFilePath);
    final package = await PackageReader.readPackage(epubArchive, rootFilePath);
    final navigation = await NavigationReader.readNavigation(
      epubArchive,
      contentDirectoryPath,
      package,
    );

    return EpubSchema(
      package: package,
      navigation: navigation,
      contentDirectoryPath: contentDirectoryPath,
    );
  }
}
