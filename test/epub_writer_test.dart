library epubreadertest;

import 'dart:io' as io;

import 'package:epub_editor/src/entities/epub_book.dart';
import 'package:epub_editor/src/epub_reader.dart';
import 'package:epub_editor/src/epub_writer.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

main() async {
  final epubs = <String, EpubBook?>{};
  final res = path.join(io.Directory.current.path, 'test', 'res');
  final dir = io.Directory(res);
  final entities = await dir.list(recursive: true).toList();
  final files = entities.whereType<io.File>();

  for (final file in files) {
    if (await file.exists()) {
      final contents = await file.readAsBytes();
      final fileName = file.uri.pathSegments[file.uri.pathSegments.length - 1];

      // TODO: fix these books
      if (fileName == 'svg-in-spine.epub' || fileName == 'trees.epub') {
        continue;
      }

      print('Reading "$fileName".');
      epubs[fileName] = await EpubReader.readBook(contents);
    }
  }

  group('Writer tests', () {
    test('Book Round Trip', () async {
      for (final epub in epubs.entries) {
        final book = epub.value;
        print('Testing "${epub.key}".');

        if (book != null) {
          final written = await EpubWriter.writeBook(book);
          final newBook = await EpubReader.readBook(written!);

          if (newBook.content != book.content) {
            final originalFiles = book.content.allFiles.keys.toSet();
            final newFiles = newBook.content.allFiles.keys.toSet();

            final intersection = originalFiles.intersection(newFiles);
            final difference = originalFiles.difference(newFiles);

            for (final file in intersection) {
              final originalFile = book.content.allFiles[file];
              final newFile = newBook.content.allFiles[file];

              if (originalFile != newFile) {
                print('[${epub.key}] Files do not match: $file');
              }
            }

            for (final file in difference) {
              print('[${epub.key}] Missing file: $file');
            }
          }

          expect(newBook, equals(book));
        }
      }
    });
  });
}
