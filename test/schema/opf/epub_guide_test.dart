library epubreadertest;

import 'dart:math' show Random;

import 'package:epub_editor/src/schema/opf/epub_guide.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

main() async {
  final generator = RandomDataGenerator(Random(123445), 10);
  final reference = generator.randomEpubGuide();

  EpubGuide? testGuide;

  setUp(() async {
    testGuide = EpubGuide(
      items: List.from(reference.items),
    );
  });

  tearDown(() async {
    testGuide = null;
  });

  group('EpubGuide', () {
    group('.equals', () {
      test('is true for equivalent objects', () async {
        expect(testGuide, equals(reference));
      });

      test('is false when Items changes', () async {
        testGuide!.items.add(generator.randomEpubGuideReference());
        expect(testGuide, isNot(reference));
      });
    });

    group('.hashCode', () {
      test('is true for equivalent objects', () async {
        expect(testGuide!.hashCode, equals(reference.hashCode));
      });

      test('is false when Items changes', () async {
        testGuide!.items.add(generator.randomEpubGuideReference());
        expect(testGuide!.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
