library epubreadertest;

import 'dart:io' as io;

import 'package:epub_editor/src/entities/epub_book.dart';
import 'package:epub_editor/src/epub_reader.dart';
import 'package:epub_editor/src/epub_writer.dart';
import 'package:epub_editor/src/writers/epub_package_writer.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

main() async {
  for (final epub in epubs.entries) {
    final fileName = epub.key;
    final fullPath = path.join(
      io.Directory.current.path,
      'test',
      'res',
      fileName,
    );
    final file = io.File(fullPath);

    if (await file.exists()) {
      final contents = await file.readAsBytes();

      epub.value['contents'] = contents;
      epub.value['book'] = await EpubReader.readBook(contents);
    }
  }

  group('Writer tests', () {
    test('Book Round Trip', () async {
      for (final epub in epubs.entries) {
        final book = epub.value['book'] as EpubBook?;

        if (book != null) {
          final written = await EpubWriter.writeBook(book);
          final bookRoundTrip = await EpubReader.readBook(written!);

          expect(bookRoundTrip, equals(book));
        }
      }
    });

    group('Epub Package Writer', () {
      test('write content formats correctly', () {
        for (final epub in epubs.entries) {
          final book = epub.value['book'] as EpubBook?;

          if (book != null) {
            final package = EpubPackageWriter.writeContent(
              book.schema.package,
            );
            final packageSplit = package.split('\n');
            final originalSplit = (epub.value['package'] as String).split('\n');
            final length = packageSplit.length < originalSplit.length
                ? packageSplit.length
                : originalSplit.length;

            for (var i = 0; i < length; i++) {
              expect(packageSplit[i], equals(originalSplit[i]));
            }
          }
        }
      });
    });
  });
}

final epubs = {
  'Frankenstein.epub': {
    'contents': <int>[],
    'book': null,
    'package': """
<?xml version="1.0" encoding="UTF-8"?>
<package version="3.0" unique-identifier="id" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.idpf.org/2007/opf">
  <metadata xmlns:opf="http://www.idpf.org/2007/opf" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <dc:creator id="author_0">Mary Wollstonecraft Shelley</dc:creator>
    <dc:date>1993-10-01</dc:date>
    <dc:identifier id="id">http://www.gutenberg.org/84</dc:identifier>
    <dc:language>en</dc:language>
    <dc:rights>Public domain in the USA.</dc:rights>
    <dc:source>https://www.gutenberg.org/files/84/84-h/84-h.htm</dc:source>
    <dc:subject>Science fiction</dc:subject>
    <dc:subject>Horror tales</dc:subject>
    <dc:subject>Gothic fiction</dc:subject>
    <dc:subject>Scientists -- Fiction</dc:subject>
    <dc:subject>Monsters -- Fiction</dc:subject>
    <dc:subject>Frankenstein, Victor (Fictitious character) -- Fiction</dc:subject>
    <dc:subject>Frankenstein's monster (Fictitious character) -- Fiction</dc:subject>
    <dc:title>Frankenstein; Or, The Modern Prometheus</dc:title>
    <meta property="file-as" refines="#author_0">Shelley, Mary Wollstonecraft</meta>
    <meta property="role" refines="#author_0" scheme="marc:relators">aut</meta>
    <meta property="dcterms:modified">2024-05-01T08:04:28Z</meta>
    <meta name="cover" content="item1"/>
  </metadata>
  <manifest>
    <item id="item1" href="426388719063252120_84-cover.png" media-type="image/png" properties="cover-image"/>
    <item id="item2" href="pgepub.css" media-type="text/css"/>
    <item id="item3" href="0.css" media-type="text/css"/>
    <item id="item4" href="1.css" media-type="text/css"/>
    <item id="pg-header" href="6789108934936275762_84-h-0.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item5" href="6789108934936275762_84-h-1.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item6" href="6789108934936275762_84-h-2.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item7" href="6789108934936275762_84-h-3.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item8" href="6789108934936275762_84-h-4.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item9" href="6789108934936275762_84-h-5.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item10" href="6789108934936275762_84-h-6.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item11" href="6789108934936275762_84-h-7.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item12" href="6789108934936275762_84-h-8.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item13" href="6789108934936275762_84-h-9.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item14" href="6789108934936275762_84-h-10.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item15" href="6789108934936275762_84-h-11.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item16" href="6789108934936275762_84-h-12.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item17" href="6789108934936275762_84-h-13.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item18" href="6789108934936275762_84-h-14.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item19" href="6789108934936275762_84-h-15.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item20" href="6789108934936275762_84-h-16.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item21" href="6789108934936275762_84-h-17.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item22" href="6789108934936275762_84-h-18.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item23" href="6789108934936275762_84-h-19.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item24" href="6789108934936275762_84-h-20.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item25" href="6789108934936275762_84-h-21.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item26" href="6789108934936275762_84-h-22.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item27" href="6789108934936275762_84-h-23.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item28" href="6789108934936275762_84-h-24.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item29" href="6789108934936275762_84-h-25.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item30" href="6789108934936275762_84-h-26.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item31" href="6789108934936275762_84-h-27.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item32" href="6789108934936275762_84-h-28.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="item33" href="6789108934936275762_84-h-29.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="pg-footer" href="6789108934936275762_84-h-30.htm.xhtml" media-type="application/xhtml+xml"/>
    <item id="ncx" href="toc.xhtml" media-type="application/xhtml+xml" properties="nav"/>
    <item id="ncx2" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
    <item id="coverpage-wrapper" href="wrap0000.xhtml" media-type="application/xhtml+xml" properties="svg"/>
  </manifest>
  <spine toc="ncx2">
    <itemref idref="coverpage-wrapper" linear="yes"/>
    <itemref idref="pg-header" linear="yes"/>
    <itemref idref="item5" linear="yes"/>
    <itemref idref="item6" linear="yes"/>
    <itemref idref="item7" linear="yes"/>
    <itemref idref="item8" linear="yes"/>
    <itemref idref="item9" linear="yes"/>
    <itemref idref="item10" linear="yes"/>
    <itemref idref="item11" linear="yes"/>
    <itemref idref="item12" linear="yes"/>
    <itemref idref="item13" linear="yes"/>
    <itemref idref="item14" linear="yes"/>
    <itemref idref="item15" linear="yes"/>
    <itemref idref="item16" linear="yes"/>
    <itemref idref="item17" linear="yes"/>
    <itemref idref="item18" linear="yes"/>
    <itemref idref="item19" linear="yes"/>
    <itemref idref="item20" linear="yes"/>
    <itemref idref="item21" linear="yes"/>
    <itemref idref="item22" linear="yes"/>
    <itemref idref="item23" linear="yes"/>
    <itemref idref="item24" linear="yes"/>
    <itemref idref="item25" linear="yes"/>
    <itemref idref="item26" linear="yes"/>
    <itemref idref="item27" linear="yes"/>
    <itemref idref="item28" linear="yes"/>
    <itemref idref="item29" linear="yes"/>
    <itemref idref="item30" linear="yes"/>
    <itemref idref="item31" linear="yes"/>
    <itemref idref="item32" linear="yes"/>
    <itemref idref="item33" linear="yes"/>
    <itemref idref="pg-footer" linear="yes"/>
  </spine>
</package>
""",
  },
  'alicesAdventuresUnderGround.epub': {
    'contents': <int>[],
    'book': null,
    'package': """
<?xml version="1.0" encoding="UTF-8"?>
<package version="2.0" unique-identifier="id" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.idpf.org/2007/opf">
  <metadata xmlns:opf="http://www.idpf.org/2007/opf" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <dc:creator opf:file-as="Carroll, Lewis">Lewis Carroll</dc:creator>
    <dc:date opf:event="publication">2006-08-07</dc:date>
    <dc:date opf:event="conversion">2017-10-10T06:35:26.576385+00:00</dc:date>
    <dc:identifier id="id" opf:scheme="URI">http://www.gutenberg.org/ebooks/19002</dc:identifier>
    <dc:language xsi:type="dcterms:RFC4646">en</dc:language>
    <dc:rights>Public domain in the USA.</dc:rights>
    <dc:source>http://www.gutenberg.org/files/19002/19002-h/19002-h.htm</dc:source>
    <dc:subject>Fantasy literature</dc:subject>
    <dc:title>Alice's Adventures Under Ground / Being a facsimile of the original Ms. book afterwards developed into "Alice's Adventures in Wonderland"</dc:title>
    <meta name="cover" content="item1"/>
  </metadata>
  <manifest>
    <item id="item1" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@cover.jpg" media-type="image/jpeg"/>
    <item id="item2" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_092.jpg" media-type="image/jpeg"/>
    <item id="item3" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_001.jpg" media-type="image/jpeg"/>
    <item id="item4" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_006.jpg" media-type="image/jpeg"/>
    <item id="item5" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_009.jpg" media-type="image/jpeg"/>
    <item id="item6" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_011.jpg" media-type="image/jpeg"/>
    <item id="item7" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_013.jpg" media-type="image/jpeg"/>
    <item id="item8" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_017.jpg" media-type="image/jpeg"/>
    <item id="item9" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_019.jpg" media-type="image/jpeg"/>
    <item id="item10" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_023.jpg" media-type="image/jpeg"/>
    <item id="item11" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_024.jpg" media-type="image/jpeg"/>
    <item id="item12" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_028.jpg" media-type="image/jpeg"/>
    <item id="item13" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_031.jpg" media-type="image/jpeg"/>
    <item id="item14" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_033.jpg" media-type="image/jpeg"/>
    <item id="item15" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_035.jpg" media-type="image/jpeg"/>
    <item id="item16" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_036.jpg" media-type="image/jpeg"/>
    <item id="item17" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_037.jpg" media-type="image/jpeg"/>
    <item id="item18" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_040.jpg" media-type="image/jpeg"/>
    <item id="item19" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_043.jpg" media-type="image/jpeg"/>
    <item id="item20" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_045.jpg" media-type="image/jpeg"/>
    <item id="item21" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_046.jpg" media-type="image/jpeg"/>
    <item id="item22" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_049.jpg" media-type="image/jpeg"/>
    <item id="item23" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_052.jpg" media-type="image/jpeg"/>
    <item id="item24" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_054.jpg" media-type="image/jpeg"/>
    <item id="item25" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_056.jpg" media-type="image/jpeg"/>
    <item id="item26" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_058.jpg" media-type="image/jpeg"/>
    <item id="item27" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_061.jpg" media-type="image/jpeg"/>
    <item id="item28" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_062.jpg" media-type="image/jpeg"/>
    <item id="item29" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_063.jpg" media-type="image/jpeg"/>
    <item id="item30" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_067.jpg" media-type="image/jpeg"/>
    <item id="item31" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_068.jpg" media-type="image/jpeg"/>
    <item id="item32" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_071.jpg" media-type="image/jpeg"/>
    <item id="item33" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_075.jpg" media-type="image/jpeg"/>
    <item id="item34" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_076.jpg" media-type="image/jpeg"/>
    <item id="item35" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_078.jpg" media-type="image/jpeg"/>
    <item id="item36" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_079.jpg" media-type="image/jpeg"/>
    <item id="item37" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_082.jpg" media-type="image/jpeg"/>
    <item id="item38" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_084.jpg" media-type="image/jpeg"/>
    <item id="item39" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_087.jpg" media-type="image/jpeg"/>
    <item id="item40" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_088.jpg" media-type="image/jpeg"/>
    <item id="item41" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@images@image_090.jpg" media-type="image/jpeg"/>
    <item id="item42" href="pgepub.css" media-type="text/css"/>
    <item id="item43" href="0.css" media-type="text/css"/>
    <item id="item44" href="1.css" media-type="text/css"/>
    <item id="item45" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@19002-h-0.htm.html" media-type="application/xhtml+xml"/>
    <item id="item46" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@19002-h-1.htm.html" media-type="application/xhtml+xml"/>
    <item id="item47" href="@public@vhost@g@gutenberg@html@files@19002@19002-h@19002-h-2.htm.html" media-type="application/xhtml+xml"/>
    <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
    <item id="coverpage-wrapper" href="wrap0000.html" media-type="application/xhtml+xml"/>
  </manifest>
  <spine toc="ncx">
    <itemref idref="coverpage-wrapper" linear="no"/>
    <itemref idref="item45" linear="yes"/>
    <itemref idref="item46" linear="yes"/>
    <itemref idref="item47" linear="yes"/>
  </spine>
  <guide>
    <reference type="toc" title="CONTENTS." href="@public@vhost@g@gutenberg@html@files@19002@19002-h@19002-h-0.htm.html#pgepubid00010"/>
    <reference type="cover" title="Cover" href="wrap0000.html"/>
  </guide>
</package>
""",
  },
  'hittelOnGoldMines.epub': {
    'contents': <int>[],
    'book': null,
    'package': """
<?xml version="1.0" encoding="UTF-8"?>
<package version="2.0" unique-identifier="id" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.idpf.org/2007/opf">
  <metadata xmlns:opf="http://www.idpf.org/2007/opf" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <dc:creator opf:file-as="Hittell, John S. (John Shertzer)">John S. Hittell</dc:creator>
    <dc:date opf:event="publication">2009-09-07</dc:date>
    <dc:date opf:event="conversion">2017-04-15T09:21:00.488992+00:00</dc:date>
    <dc:identifier id="id" opf:scheme="URI">http://www.gutenberg.org/ebooks/29926</dc:identifier>
    <dc:language xsi:type="dcterms:RFC4646">en</dc:language>
    <dc:rights>Public domain in the USA.</dc:rights>
    <dc:source>http://www.gutenberg.org/files/29926/29926-h/29926-h.htm</dc:source>
    <dc:subject>Gold mines and mining</dc:subject>
    <dc:title>Hittel on Gold Mines and Mining</dc:title>
  </metadata>
  <manifest>
    <item id="item1" href="pgepub.css" media-type="text/css"/>
    <item id="item2" href="0.css" media-type="text/css"/>
    <item id="item3" href="@public@vhost@g@gutenberg@html@files@29926@29926-h@29926-h-0.htm.html" media-type="application/xhtml+xml"/>
    <item id="item4" href="@public@vhost@g@gutenberg@html@files@29926@29926-h@29926-h-1.htm.html" media-type="application/xhtml+xml"/>
    <item id="item5" href="@public@vhost@g@gutenberg@html@files@29926@29926-h@29926-h-2.htm.html" media-type="application/xhtml+xml"/>
    <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
  </manifest>
  <spine toc="ncx">
    <itemref idref="item3" linear="yes"/>
    <itemref idref="item4" linear="yes"/>
    <itemref idref="item5" linear="yes"/>
  </spine>
</package>
""",
  },
};
