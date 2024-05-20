library epubreadertest;

import 'dart:io' as io;

import 'package:epub_editor/src/entities/epub_book.dart';
import 'package:epub_editor/src/epub_reader.dart';
import 'package:epub_editor/src/epub_writer.dart';
import 'package:epub_editor/src/writers/epub_package_writer.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

main() async {
  String fileName = "alicesAdventuresUnderGround.epub";
  String fullPath =
      path.join(io.Directory.current.path, "test", "res", fileName);
  final targetFile = io.File(fullPath);
  if (!(await targetFile.exists())) {
    throw Exception("Specified epub file not found: ${fullPath}");
  }

  List<int> bytes = await targetFile.readAsBytes();
  EpubBook book = await EpubReader.readBook(bytes);

  group("Writer tests", () {
    test("Book Round Trip", () async {
      final written = await EpubWriter.writeBook(book);
      final bookRoundTrip = await EpubReader.readBook(written!);

      expect(bookRoundTrip, equals(book));
    });

    group("Epub Package Writer", () {
      test("write content formats correctly", () {
        final package = EpubPackageWriter.writeContent(book.schema!.package!);
        print(package);
        expect(true, equals(false));
      });
    });
  });
}
