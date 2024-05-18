library epubreadertest;

import 'dart:io' as io;

import 'package:epub_editor/epub.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

main() async {
  String fileName = "alicesAdventuresUnderGround.epub";
  String fullPath =
      path.join(io.Directory.current.path, "test", "res", fileName);
  final targetFile = new io.File(fullPath);
  if (!(await targetFile.exists())) {
    throw new Exception("Specified epub file not found: ${fullPath}");
  }

  List<int> bytes = await targetFile.readAsBytes();

  test("Book Round Trip", () async {
    EpubBook book = await EpubReader.readBook(bytes);

    final written = await EpubWriter.writeBook(book);
    final bookRoundTrip = await EpubReader.readBook(written);

    expect(bookRoundTrip, equals(book));
  });
}
