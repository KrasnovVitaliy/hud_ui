Map<K, V> sortMapByKey<K, V>(Map<K, V> map, {int Function(K a, K b)? compare, bool descending = false}) {
  final entries = map.entries.toList();

  entries.sort((a, b) {
    final cmp = compare != null ? compare(a.key, b.key) : (a.key as Comparable).compareTo(b.key);

    return descending ? -cmp : cmp;
  });

  return Map.fromEntries(entries);
}
