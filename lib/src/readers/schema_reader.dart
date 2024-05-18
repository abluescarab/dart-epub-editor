import 'dart:async';

import 'package:archive/archive.dart';

import '../entities/epub_schema.dart';
import '../utils/zip_path_utils.dart';
import 'navigation_reader.dart';
import 'package_reader.dart';
import 'root_file_path_reader.dart';

class SchemaReader {
  static Future<EpubSchema> readSchema(Archive epubArchive) async {
    final result = EpubSchema();

    final rootFilePath = (await RootFilePathReader.getRootFilePath(epubArchive))!;
    final contentDirectoryPath = ZipPathUtils.getDirectoryPath(rootFilePath);
    result.contentDirectoryPath = contentDirectoryPath;

    final package = await PackageReader.readPackage(epubArchive, rootFilePath);
    result.package = package;

    final navigation = await NavigationReader.readNavigation(
        epubArchive, contentDirectoryPath, package);
    result.navigation = navigation;

    return result;
  }
}
