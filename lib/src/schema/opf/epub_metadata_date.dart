import 'package:epub_editor/src/schema/opf/epub_metadata_field.dart';
import 'package:quiver/core.dart';

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
    if (!(other is EpubMetadataDate)) {
      return false;
    }

    return id == other.id && date == other.date && event == other.event;
  }
}
