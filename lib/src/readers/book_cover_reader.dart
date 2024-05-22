import 'package:collection/collection.dart';
import 'package:epub_editor/src/ref_entities/epub_book_ref.dart';
import 'package:epub_editor/src/ref_entities/epub_byte_content_file_ref.dart';

class BookCoverReader {
  static Future<EpubByteContentFileRef?> readBookCover(
    EpubBookRef bookRef,
  ) async {
    final manifest = bookRef.schema.package.manifest;

    // ------------------- Version 3 method ------------------- //
    // - Read cover image in version 3 method.
    if (manifest.items.isNotEmpty) {
      final coverImageItem = manifest.items.firstWhereOrNull(
          (epubManifestItem) => epubManifestItem.properties == 'cover-image');

      if (coverImageItem != null) {
        final epubByteContentFileRef =
            bookRef.content?.images[coverImageItem.href];

        if (epubByteContentFileRef != null) {
          return epubByteContentFileRef;
        }
      }
    }

    // ------------------- Version 2 method ------------------- //
    // - Read cover image in version 2 method.
    final metaItems = bookRef.schema.package.metadata.metaItems;

    if (metaItems.isEmpty) {
      return null;
    }

    final coverMetaItem = metaItems.firstWhereOrNull((metaItem) =>
        metaItem.name != null && metaItem.name!.toLowerCase() == 'cover');

    if (coverMetaItem == null) {
      return null;
    }

    if ([null, '', ' '].contains(coverMetaItem.content)) {
      throw Exception(
        'Incorrect EPUB metadata: cover item content is missing.',
      );
    }

    final coverManifestItem = bookRef.schema.package.manifest.items
        .firstWhereOrNull((manifestItem) =>
            manifestItem.id!.toLowerCase() ==
            coverMetaItem.content!.toLowerCase());

    if (coverManifestItem == null) {
      throw Exception(
        'Incorrect EPUB manifest: item with ID = "${coverMetaItem.content}" '
        'is missing.',
      );
    }

    if (!bookRef.content!.images.containsKey(coverManifestItem.href)) {
      throw Exception(
        'Incorrect EPUB manifest: item with href = "${coverManifestItem.href}" '
        'is missing.',
      );
    }

    return bookRef.content!.images[coverManifestItem.href];
  }
}
