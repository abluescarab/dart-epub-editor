import 'package:quiver/core.dart';

import 'epub_language_related_attributes.dart';

class EpubMetadataMeta {
  String? name;
  String? content;
  String? textContent;
  String? id;
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
