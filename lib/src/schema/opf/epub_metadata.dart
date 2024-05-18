import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_metadata_contributor.dart';
import 'epub_metadata_date.dart';
import 'epub_metadata_identifier.dart';
import 'epub_metadata_meta.dart';
import 'epub_metadata_string.dart';
import 'epub_metadata_translated_string.dart';

class EpubMetadata {
  List<EpubMetadataContributor>? contributors;
  List<EpubMetadataTranslatedString>? coverages;
  List<EpubMetadataContributor>? creators;
  List<EpubMetadataDate>? dates;
  List<EpubMetadataTranslatedString>? descriptions;
  List<EpubMetadataString>? formats;
  List<EpubMetadataIdentifier>? identifiers;
  List<EpubMetadataString>? languages;
  List<EpubMetadataMeta>? metaItems;
  List<EpubMetadataTranslatedString>? publishers;
  List<EpubMetadataTranslatedString>? relations;
  List<EpubMetadataTranslatedString>? rights;
  List<EpubMetadataString>? sources;
  List<EpubMetadataTranslatedString>? subjects;
  List<EpubMetadataTranslatedString>? titles;
  List<EpubMetadataString>? types;

  @override
  int get hashCode {
    final objects = [
      ...contributors!.map((contributor) => contributor.hashCode),
      ...coverages!.map((coverage) => coverage.hashCode),
      ...creators!.map((creator) => creator.hashCode),
      ...dates!.map((date) => date.hashCode),
      ...descriptions!.map((description) => description.hashCode),
      ...formats!.map((format) => format.hashCode),
      ...identifiers!.map((identifier) => identifier.hashCode),
      ...languages!.map((language) => language.hashCode),
      ...metaItems!.map((metaItem) => metaItem.hashCode),
      ...publishers!.map((publisher) => publisher.hashCode),
      ...relations!.map((relation) => relation.hashCode),
      ...rights!.map((right) => right.hashCode),
      ...sources!.map((source) => source.hashCode),
      ...subjects!.map((subject) => subject.hashCode),
      ...titles!.map((title) => title.hashCode),
      ...types!.map((type) => type.hashCode),
    ];

    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    final otherAs = other as EpubMetadata?;
    if (otherAs == null) return false;

    if (!collections.listsEqual(contributors, otherAs.contributors) ||
        !collections.listsEqual(coverages, otherAs.coverages) ||
        !collections.listsEqual(creators, otherAs.creators) ||
        !collections.listsEqual(dates, otherAs.dates) ||
        !collections.listsEqual(descriptions, otherAs.descriptions) ||
        !collections.listsEqual(formats, otherAs.formats) ||
        !collections.listsEqual(identifiers, otherAs.identifiers) ||
        !collections.listsEqual(languages, otherAs.languages) ||
        !collections.listsEqual(metaItems, otherAs.metaItems) ||
        !collections.listsEqual(publishers, otherAs.publishers) ||
        !collections.listsEqual(relations, otherAs.relations) ||
        !collections.listsEqual(rights, otherAs.rights) ||
        !collections.listsEqual(sources, otherAs.sources) ||
        !collections.listsEqual(subjects, otherAs.subjects) ||
        !collections.listsEqual(titles, otherAs.titles) ||
        !collections.listsEqual(types, otherAs.types)) {
      return false;
    }

    return true;
  }
}
