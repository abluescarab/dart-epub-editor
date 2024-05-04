import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_metadata_contributor.dart';
import 'epub_metadata_creator.dart';
import 'epub_metadata_date.dart';
import 'epub_metadata_identifier.dart';
import 'epub_metadata_meta.dart';
import 'epub_metadata_string.dart';
import 'epub_metadata_translated_string.dart';

class EpubMetadata {
  List<EpubMetadataTranslatedString>? titles;
  List<EpubMetadataCreator>? creators;
  List<EpubMetadataTranslatedString>? subjects;
  List<EpubMetadataTranslatedString>? descriptions;
  List<EpubMetadataTranslatedString>? publishers;
  List<EpubMetadataContributor>? contributors;
  List<EpubMetadataDate>? dates;
  List<EpubMetadataString>? types;
  List<EpubMetadataString>? formats;
  List<EpubMetadataIdentifier>? identifiers;
  List<EpubMetadataString>? sources;
  List<EpubMetadataString>? languages;
  List<EpubMetadataTranslatedString>? relations;
  List<EpubMetadataTranslatedString>? coverages;
  List<EpubMetadataTranslatedString>? rights;
  List<EpubMetadataMeta>? metaItems;

  @override
  int get hashCode {
    var objects = [
      ...titles!.map((title) => title.hashCode),
      ...creators!.map((creator) => creator.hashCode),
      ...subjects!.map((subject) => subject.hashCode),
      ...publishers!.map((publisher) => publisher.hashCode),
      ...contributors!.map((contributor) => contributor.hashCode),
      ...dates!.map((date) => date.hashCode),
      ...types!.map((type) => type.hashCode),
      ...formats!.map((format) => format.hashCode),
      ...identifiers!.map((identifier) => identifier.hashCode),
      ...sources!.map((source) => source.hashCode),
      ...languages!.map((language) => language.hashCode),
      ...relations!.map((relation) => relation.hashCode),
      ...coverages!.map((coverage) => coverage.hashCode),
      ...rights!.map((right) => right.hashCode),
      ...metaItems!.map((metaItem) => metaItem.hashCode),
      ...descriptions!.map((description) => description.hashCode),
    ];

    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadata?;
    if (otherAs == null) return false;

    if (!collections.listsEqual(titles, otherAs.titles) ||
        !collections.listsEqual(creators, otherAs.creators) ||
        !collections.listsEqual(subjects, otherAs.subjects) ||
        !collections.listsEqual(publishers, otherAs.publishers) ||
        !collections.listsEqual(contributors, otherAs.contributors) ||
        !collections.listsEqual(dates, otherAs.dates) ||
        !collections.listsEqual(types, otherAs.types) ||
        !collections.listsEqual(formats, otherAs.formats) ||
        !collections.listsEqual(identifiers, otherAs.identifiers) ||
        !collections.listsEqual(sources, otherAs.sources) ||
        !collections.listsEqual(languages, otherAs.languages) ||
        !collections.listsEqual(relations, otherAs.relations) ||
        !collections.listsEqual(coverages, otherAs.coverages) ||
        !collections.listsEqual(rights, otherAs.rights) ||
        !collections.listsEqual(metaItems, otherAs.metaItems) ||
        !collections.listsEqual(descriptions, otherAs.descriptions)) {
      return false;
    }

    return true;
  }
}
