import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

class RootFilePathReader {
  static Future<String?> getRootFilePath(Archive epubArchive) async {
    const epubContainerFilePath = 'META-INF/container.xml';
    final containerFileEntry = epubArchive.files.firstWhereOrNull(
      (file) => file.name == epubContainerFilePath,
    );

    if (containerFileEntry == null) {
      throw Exception(
        'EPUB parsing error: $epubContainerFilePath file not found in archive.',
      );
    }

    final packageElement =
        XmlDocument.parse(utf8.decode(containerFileEntry.content))
            .findAllElements(
              'container',
              namespace: 'urn:oasis:names:tc:opendocument:xmlns:container',
            )
            .firstOrNull;

    if (packageElement == null) {
      throw Exception('EPUB parsing error: Invalid epub container');
    }

    final rootFileElement = packageElement.descendants.firstWhereOrNull(
      (testElem) {
        return (testElem is XmlElement) && 'rootfile' == testElem.name.local;
      },
    ) as XmlElement;

    return rootFileElement.getAttribute('full-path');
  }
}
