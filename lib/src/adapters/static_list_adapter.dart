import '../../listview_utils_plus.dart';

class StaticListAdapter<T> implements BaseListAdapter<T> {
  final Iterable<T> data;
  final bool disablePagination;

  const StaticListAdapter({
    required this.data,
    this.disablePagination = false,
  });

  @override
  Future<ListItems<T>> getItems(int offset, int limit) {
    if (disablePagination) {
      return Future.value(ListItems(data, reachedToEnd: data.isEmpty));
    } else {
      var items = data.skip(offset).take(limit).toList();
      return Future.value(ListItems(items, reachedToEnd: items.length < limit));
    }
  }

  @override
  bool shouldUpdate(StaticListAdapter<T> old) =>
      (disablePagination != old.disablePagination) || (data != old.data);
}
