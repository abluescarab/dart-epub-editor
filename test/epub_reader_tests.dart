library epubreadertest;

import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:epub_editor/epub_editor.dart';

main() async {
  String fileName = "Frankenstein.epub";
  String fullPath =
      path.join(io.Directory.current.path, "test", "res", fileName);
  final targetFile =  io.File(fullPath);
  if (!(await targetFile.exists())) {
    throw  Exception("Specified epub file not found: ${fullPath}");
  }

  List<int> bytes = await targetFile.readAsBytes();
  test("Test Epub Ref", () async {
    EpubBookRef epubRef = await EpubReader.openBook(bytes);
    final t = await epubRef.getChapters();
    print("${t.length}");
  });

  test("Test Epub Read", () async {
    EpubBook epubRef = await EpubReader.readBook(bytes);

    expect(epubRef.author, equals("Mary Wollstonecraft Shelley"));
    expect(
      epubRef.mainTitle.value,
      equals("Frankenstein; Or, The Modern Prometheus"),
    );
  });

  test("Test can read", () async {
    String baseName =
        path.join(io.Directory.current.path, "test", "res", "std");
    io.Directory baseDir = io.Directory(baseName);
    if (!(await baseDir.exists())) {
      throw Exception("Base path does not exist: ${baseName}");
    }

    await baseDir
        .list(recursive: false, followLinks: false)
        .forEach((io.FileSystemEntity fe) async {
      if (fe.path.contains("epub30-spec.epub")) {
        try {
          io.File tf = io.File(fe.path);
          List<int> bytes = await tf.readAsBytes();
          EpubBook book = await EpubReader.readBook(bytes);
          expect(book, isNotNull);
        } catch (e) {
          print("File: ${fe.path}, Exception: ${e}");
          fail("Caught error...");
        }
      }
    });
  });

  test("Test can open", () async {
    final baseName = path.join(io.Directory.current.path, "test", "res", "std");
    final baseDir = io.Directory(baseName);
    if (!(await baseDir.exists())) {
      throw Exception("Base path does not exist: ${baseName}");
    }

    await baseDir
        .list(recursive: false, followLinks: false)
        .forEach((io.FileSystemEntity fe) async {
      try {
        final tf = io.File(fe.path);
        final bytes = await tf.readAsBytes();
        final ref = await EpubReader.openBook(bytes);
        expect(ref, isNotNull);
      } catch (e) {
        print("File: ${fe.path}, Exception: ${e}");
        fail("Caught error...");
      }
    });
  });
}
