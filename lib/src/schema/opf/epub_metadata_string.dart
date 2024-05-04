import 'package:epub_editor/epub_editor.dart';
import 'package:quiver/core.dart';

class EpubMetadataString {
  EpubMetadataString({
    required this.id,
    required this.value,
    required this.languageRelatedAttributes,
  });

  String? id;
  String value;
  EpubLanguageRelatedAttributes languageRelatedAttributes;

  @override
  int get hashCode => hash3(id, value, languageRelatedAttributes);

  @override
  bool operator ==(Object other) {
    final otherAs = other as EpubMetadataString?;

    if (otherAs == null) {
      return false;
    }

    return id == otherAs.id &&
        value == otherAs.value &&
        languageRelatedAttributes == otherAs.languageRelatedAttributes;
  }
}
