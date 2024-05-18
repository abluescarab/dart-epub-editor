import 'package:quiver/core.dart';

import 'epub_metadata_field.dart';

class EpubMetadataDate extends EpubMetadataField {
  EpubMetadataDate({
    super.id,
    this.date,
    this.event,
  });

  String? date;
  String? event;

  @override
  int get hashCode => hash3(id.hashCode, date.hashCode, event.hashCode);

  @override
  bool operator ==(other) {
    final otherAs = other as EpubMetadataDate?;
    if (otherAs == null) return false;
    return id == otherAs.id && date == otherAs.date && event == otherAs.event;
  }
}
