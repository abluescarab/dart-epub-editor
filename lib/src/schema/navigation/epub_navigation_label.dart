
class EpubNavigationLabel {
  EpubNavigationLabel({
    this.text,
  });

  String? text;

  @override
  int get hashCode => text.hashCode;

  @override
  bool operator ==(other) {
    if (!(other is EpubNavigationLabel)) {
      return false;
    }

    return text == other.text;
  }

  @override
  String toString() {
    return text!;
  }
}
