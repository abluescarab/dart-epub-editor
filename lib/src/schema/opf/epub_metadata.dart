import 'package:epub_editor/src/schema/opf/epub_metadata_contributor.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_date.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_identifier.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_meta.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_string.dart';
import 'package:epub_editor/src/schema/opf/epub_metadata_translated_string.dart';
import 'package:quiver/collection.dart';

class EpubMetadata {
  EpubMetadata({
    this.contributors,
    this.coverages,
    this.creators,
    this.dates,
    this.descriptions,
    this.formats,
    this.identifiers,
    this.languages,
    this.metaItems,
    this.publishers,
    this.relations,
    this.rights,
    this.sources,
    this.subjects,
    this.titles,
    this.types,
  });

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
  int get hashCode => Object.hashAll([
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
      ]);

  @override
  bool operator ==(other) {
    if (!(other is EpubMetadata)) {
      return false;
    }

    return listsEqual(contributors, other.contributors) &&
        listsEqual(coverages, other.coverages) &&
        listsEqual(creators, other.creators) &&
        listsEqual(dates, other.dates) &&
        listsEqual(descriptions, other.descriptions) &&
        listsEqual(formats, other.formats) &&
        listsEqual(identifiers, other.identifiers) &&
        listsEqual(languages, other.languages) &&
        listsEqual(metaItems, other.metaItems) &&
        listsEqual(publishers, other.publishers) &&
        listsEqual(relations, other.relations) &&
        listsEqual(rights, other.rights) &&
        listsEqual(sources, other.sources) &&
        listsEqual(subjects, other.subjects) &&
        listsEqual(titles, other.titles) &&
        listsEqual(types, other.types);
  }
}
