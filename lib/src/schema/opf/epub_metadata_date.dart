import 'package:quiver/core.dart';

class EpubMetadataDate {
  EpubMetadataDate({
    this.id,
    this.date,
    this.event,
  });

  String? id;
  String? date;
  String? event;

  @override
  int get hashCode => hash3(id.hashCode, date.hashCode, event.hashCode);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataDate?;
    if (otherAs == null) return false;
    return id == otherAs.id && date == otherAs.date && event == otherAs.event;
  }
}
