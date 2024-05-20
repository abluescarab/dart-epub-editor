library epubreadertest;

import 'dart:io' as io;

import 'package:epub_editor/src/entities/epub_book.dart';
import 'package:epub_editor/src/epub_reader.dart';
import 'package:epub_editor/src/epub_writer.dart';
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

  test("Book Round Trip", () async {
    EpubBook book = await EpubReader.readBook(bytes);

    final written = await EpubWriter.writeBook(book);
    final bookRoundTrip = await EpubReader.readBook(written!);

    expect(bookRoundTrip, equals(book));
  });
}
