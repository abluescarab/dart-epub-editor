class EnumFromString<T> {
  EnumFromString(this.enumValues);

  List<T> enumValues;

  T? get(String value) {
    value = '$T.$value';

    try {
      final x = enumValues.firstWhere(
        (f) => f.toString().toUpperCase() == value.toUpperCase(),
      );

      return x;
    } catch (e) {
      return null;
    }
  }
}
