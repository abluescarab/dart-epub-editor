import 'package:quiver/core.dart';

import 'epub_language_related_attributes.dart';
import 'epub_metadata_field.dart';

class EpubMetadataMeta extends EpubMetadataField {
  EpubMetadataMeta({
    super.id,
    this.name,
    this.content,
    this.textContent,
    this.refines,
    this.property,
    this.scheme,
    this.languageRelatedAttributes,
    this.attributes,
  });

  String? name;
  String? content;
  String? textContent;
  String? refines;
  String? property;
  String? scheme;
  EpubLanguageRelatedAttributes? languageRelatedAttributes;
  Map<String, String>? attributes;

  @override
  int get hashCode => hashObjects([
        name.hashCode,
        content.hashCode,
        textContent.hashCode,
        id.hashCode,
        refines.hashCode,
        property.hashCode,
        scheme.hashCode,
        languageRelatedAttributes.hashCode,
      ]);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataMeta?;
    if (otherAs == null) return false;
    return name == otherAs.name &&
        content == otherAs.content &&
        textContent == otherAs.textContent &&
        id == otherAs.id &&
        refines == otherAs.refines &&
        property == otherAs.property &&
        scheme == otherAs.scheme &&
        languageRelatedAttributes == otherAs.languageRelatedAttributes;
  }
}
