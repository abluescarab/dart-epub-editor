import 'package:quiver/core.dart';

class EpubSpineItemRef {
  EpubSpineItemRef({
    this.idRef,
    this.isLinear,
  });

  String? idRef;
  bool? isLinear;

  @override
  int get hashCode => hash2(idRef.hashCode, isLinear.hashCode);

  @override
  bool operator ==(other) {
    if (!(other is EpubSpineItemRef)) {
      return false;
    }

    return idRef == other.idRef && isLinear == other.isLinear;
  }
}
