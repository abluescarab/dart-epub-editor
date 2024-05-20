[EpubReader - C#](https://github.com/vers-one/EpubReader) &gt; [dart-epub](https://github.com/orthros/dart-epub) &gt; [epubx.dart](https://github.com/ScerIO/epubx.dart) &gt; [epubx](https://github.com/PresKhaled/epubx) &gt; `this`

# epub_editor

It package is [dart-epub](https://github.com/orthros/dart-epub) fork

[Flutter UI implementation](https://pub.dev/packages/epub_view)

Epub Reader and Writer for Dart inspired by [this fantastic C# Epub Reader](https://github.com/versfx/EpubReader)

This does not rely on the ```dart:io``` package in any way, so it is avilable for both desktop and web-based implementations

<!-- [![pub package](https://img.shields.io/pub/v/epubx.svg)](https://pub.dartlang.org/packages/epubx) -->
## Installing
Add the package to the ```dependencies``` section of your pubspec.yaml
```
dependencies:
  epub_editor:
    git:
      url: https://github.com/abluescarab/dart-epub-editor.git
      ref: dev
```

## Example
```dart

//Get the epub into memory somehow
String fileName = 'sample.epub';
String fullPath = path.join(io.Directory.current.path, fileName);
var targetFile = new io.File(fullPath);
List<int> bytes = await targetFile.readAsBytes();


// Opens a book and reads all of its content into memory
EpubBook epubBook = await EpubReader.readBook(bytes);

// COMMON PROPERTIES

// Book's title
String title = epubBook.title;

// Book's authors (comma separated list)
String author = epubBook.author;

// Book's authors (list of authors names)
List<String> authors = epubBook.authorList;

// Book's cover image (null if there is no cover)
Image coverImage = epubBook.coverImage;


// CHAPTERS

// Enumerating chapters
epubBook.chapters.forEach((EpubChapter chapter) {
  // Title of chapter
  String chapterTitle = chapter.title;

  // HTML content of current chapter
  String chapterHtmlContent = chapter.htmlContent;

  // Nested chapters
  List<EpubChapter> subChapters = chapter.subChapters;
});


// CONTENT

// Book's content (HTML files, stylesheets, images, fonts, etc.)
EpubContent bookContent = epubBook.content;


// IMAGES

// All images in the book (file name is the key)
Map<String, EpubByteContentFile> images = bookContent.images;

EpubByteContentFile firstImage = images.values.first;

// Content type (e.g. EpubContentType.image_jpeg, EpubContentType.image_png)
EpubContentType contentType = firstImage.contentType;

// MIME type (e.g. "image/jpeg", "image/png")
String mimeContentType = firstImage.contentMimeType;

// HTML & CSS

// All XHTML files in the book (file name is the key)
Map<String, EpubTextContentFile> htmlFiles = bookContent.html;

// All CSS files in the book (file name is the key)
Map<String, EpubTextContentFile> cssFiles = bookContent.css;

// Entire HTML content of the book
htmlFiles.values.forEach((EpubTextContentFile htmlFile) {
  String htmlContent = htmlFile.content;
});

// All CSS content in the book
cssFiles.values.forEach((EpubTextContentFile cssFile){
  String cssContent = cssFile.content;
});


// OTHER CONTENT

// All fonts in the book (file name is the key)
Map<String, EpubByteContentFile> fonts = bookContent.fonts;

// All files in the book (including HTML, CSS, images, fonts, and other types of files)
Map<String, EpubContentFile> allFiles = bookContent.allFiles;


// ACCESSING RAW SCHEMA INFORMATION

// EPUB OPF data
EpubPackage package = epubBook.schema.package;

// Enumerating book's contributors
package.metadata.contributors.forEach((EpubMetadataContributor contributor){
  String contributorName = contributor.name;
  String contributorRole = contributor.role;
});

// EPUB NCX data
EpubNavigation navigation = epubBook.schema.navigation;

// Enumerating NCX metadata
navigation.head.metadata.forEach((EpubNavigationHeadMeta meta){
  String metadataItemName = meta.name;
  String metadataItemContent = meta.content;
});

// Writing Data
var written = await EpubWriter.writeBook(epubBook);

// You can even re-read the book into a new object!
var bookRoundTrip = await EpubReader.readBook(written);
```
