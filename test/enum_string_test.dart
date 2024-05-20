library epubtest;

import 'package:epub_editor/src/utils/enum_from_string.dart';
import 'package:test/test.dart';

main() {
  test("Enum one", () {
    expect(
        EnumFromString<Simple>(Simple.values).get("one"), equals(Simple.one));
  });
  test("Enum two", () {
    expect(
        EnumFromString<Simple>(Simple.values).get("two"), equals(Simple.two));
  });
  test("Enum one", () {
    expect(EnumFromString<Simple>(Simple.values).get("three"),
        equals(Simple.three));
  });
  test("Enum one Lower Case", () {
    expect(
        EnumFromString<Simple>(Simple.values).get("one"), equals(Simple.one));
  });
}

enum Simple { one, two, three }
