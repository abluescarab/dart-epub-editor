library epubtest;

import 'package:test/test.dart';

import 'package:epub_editor/epub.dart';

main() {
  test("Enum one", () {
    expect(new EnumFromString<Simple>(Simple.values).get("one"),
        equals(Simple.one));
  });
  test("Enum two", () {
    expect(new EnumFromString<Simple>(Simple.values).get("two"),
        equals(Simple.two));
  });
  test("Enum one", () {
    expect(new EnumFromString<Simple>(Simple.values).get("three"),
        equals(Simple.three));
  });
  test("Enum one Lower Case", () {
    expect(new EnumFromString<Simple>(Simple.values).get("one"),
        equals(Simple.one));
  });
}

enum Simple { one, two, three }
