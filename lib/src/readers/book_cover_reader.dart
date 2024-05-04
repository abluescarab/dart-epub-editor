import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_byte_content_file_ref.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_metadata_meta.dart';

class BookCoverReader {
  //images.image
  static Future<EpubByteContentFileRef?> readBookCover(
      EpubBookRef bookRef) async {
    var manifest = bookRef.schema!.package!.manifest;

    // ------------------- Version 3 method ------------------- //
    // - Read cover image in version 3 method.
    if (manifest?.items != null && manifest!.items!.isNotEmpty) {
      var coverImageItem = manifest.items!.firstWhereOrNull(
        (EpubManifestItem epubManifestItem) {
          return (epubManifestItem.properties == 'cover-image');
        },
      );

      /*print('Manifest item (cover)');
      print('Properties: ${coverImageItem?.properties}|MediaType: ${coverImageItem?.mediaType}|Href: ${coverImageItem?.href}');*/

      if (coverImageItem != null) {
        var epubByteContentFileRef =
            bookRef.content?.images?[coverImageItem.href];

        if (epubByteContentFileRef != null) return epubByteContentFileRef;
      }
    }

    // ------------------- Version 2 method ------------------- //
    // - Read cover image in version 2 method.
    var metaItems = bookRef.schema!.package!.metadata!.metaItems;
    if (metaItems == null || metaItems.isEmpty) return null;

    var coverMetaItem = metaItems.firstWhereOrNull(
        (EpubMetadataMeta metaItem) =>
            metaItem.name != null && metaItem.name!.toLowerCase() == 'cover');

    if (coverMetaItem == null) return null;

    /*print('Meta item (cover)');
    print('name: ${coverMetaItem.name}|property: ${coverMetaItem.property}|content: ${coverMetaItem.content}');*/

    if ([null, '', ' '].contains(coverMetaItem.content)) {
      throw Exception(
          'Incorrect EPUB metadata: cover item content is missing.');
    }

    var coverManifestItem = bookRef.schema!.package!.manifest!.items!
        .firstWhereOrNull((EpubManifestItem manifestItem) =>
            manifestItem.id!.toLowerCase() ==
            coverMetaItem.content!.toLowerCase());
    if (coverManifestItem == null) {
      throw Exception(
          'Incorrect EPUB manifest: item with ID = \"${coverMetaItem.content}\" is missing.');
    }

    // EpubByteContentFileRef? coverImageContentFileRef;
    if (!bookRef.content!.images!.containsKey(coverManifestItem.href)) {
      throw Exception(
          'Incorrect EPUB manifest: item with href = \"${coverManifestItem.href}\" is missing.');
    }

    var coverImageContentFileRef =
        bookRef.content!.images![coverManifestItem.href];

    return coverImageContentFileRef;
  }
}
