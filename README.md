# 📜 listview_utils_plus

[![pub package](https://img.shields.io/pub/v/listview_utils.svg)](https://pub.dev/packages/listview_utils_plus)
[![GitHub](https://img.shields.io/github/license/TheMisir/flutter-listutils)](https://github.com/CsabaConsulting/listview_utils_plus/blob/master/LICENSE)
![Platform](https://img.shields.io/badge/platform-web%20%7C%20android%20%7C%20ios-ff69b4)

Supercharge `ListView` with custom adapters to add infinite scrolling.

## Origin

This is the continuation of the [listview_utils](https://pub.dev/packages/listview_utils/)
([source code](https://github.com/themisir/flutter-listutils/)). Even though @themisir
doesn't advise using it in favor of traditional state handling (RiverPod2, Provider, BLoC, etc.)
I believe it still has a legitimate use when for example you want to show 180+ objects stored
in a Floor (SQLite wrapper) or Moor DB in a list and don't want to repeat paging and other logic
half a dozen times throughout your app. But consider his advice, possibly he is right. I'm not at
the point with my project currently to realize his point.

## Example

```dart
CustomListView(
  loadingBuilder: CustomListLoading.defaultBuilder,
  itemBuilder: (context, index, item) {
    return ListTile(
      title: Text(item['title']),
    );
  },
  adapter: NetworkListAdapter(
    url: 'https://jsonplaceholder.typicode.com/posts',
    limitParam: '_limit',
    offsetParam: '_start',
  ),
);
```

## Getting Started

Add those lines to `pubspec.yaml` file and run `flutter pub get`.

```yaml
dependencies:
  listview_utils_plus: ">=0.0.1 <1.0.0"
```

Check out [Installing](https://pub.dev/packages/listview_utils_plus#-installing-tab-) tab for more details.

Import **listview_utils_plus** package to your application by adding this line:

```dart
import 'package:listview_utils_plus/listview_utils_plus.dart';
```

This will import required classes to use **listview_utils_plus**.

## Properties

```dart
CustomListView( 
  // Items fetched per request (default: 30)
  pageSize: 30,

  // Header widget (default: null)
  header: Container(...),

  // Footer widget (default: null)
  footer: Container(...),

  // The widget that displayed if the list is empty (default: null)
  empty: Text('List is empty'),

  // Item provider adapter (default: null)
  adapter: ListAdapter(
    fetchItems: (int offset, int limit) {
      return ListItems([ ... ]);
    },
  ),
  
  //Pagination Mode [offset/page] (default: offset)
  paginationMode: PaginationMode.offset 
  
  //Initial offset (default: 0)
  initialOffset: 0
  


  // A callback function to build list items (required)
  itemBuilder: (BuildContext context, int index, dynamic item) {
    // If items provided by adapter the `item` argument will be matching element
    return ListTile(
      title: Text(item['title']),
    );
  },

  // Callback function to build widget if exception occurs during fetching items
  errorBuilder: (BuildContext context, LoadErrorDetails details, CustomListViewState state) {
    return Column(
      children: <Widget>[
        Text(details.error.toString()),
        RaisedButton(
          onPressed: () => state.loadMore(),
          child: Text('Retry'),
        ),
      ],
    );
  },

  // Item count
  itemCount: 45,

  // A callback function called when pull to refresh is triggered
  onRefresh: () async {
    ...
  },

  // Enable / disable pull to refresh (default: false)
  disableRefresh: false,
),
```

## Adapters

ListView Utils currently only supports network adapter. Or you could write your own adapter by implementing `BaseListAdapter` mixin or using `ListAdapter` class.

Here's simple network adapter code using jsonplaceholder data.

```dart
NetworkListAdapter(
  url: 'https://jsonplaceholder.typicode.com/posts',
  limitParam: '_limit',
  offsetParam: '_start',
),
```

## Controllers
### Scroll controller
ListView Utils supports Flutter's built-in [`ScrollController`](https://api.flutter.dev/flutter/widgets/ScrollController-class.html),
which allows for controlling the scrolling position:

```dart
class _SomeWidgetState extends State<SomeWidget> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
          onPressed: () {
            scrollController.animateTo(100);
          },
          child: const Text('Scroll down'),
        ),
        Expanded(
          child: CustomListView(
            adapter: ...,
            scrollController: scrollController,
            itemBuilder: (context, index, dynamic item) {
              return ListTile(
                title: Text(item['title']),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
```

### List controller
ListView Utils also supports its own custom controller, which allows for controlling the list of items
(for example, programmatically refreshing the list):

```dart
class _SomeWidgetState extends State<SomeWidget> {
  CustomListViewController listViewController = CustomListViewController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
          onPressed: () {
            listViewController.refresh();
          },
          child: const Text('Refresh'),
        ),
        Expanded(
          child: CustomListView(
            adapter: ...,
            loadingBuilder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            scrollController: scrollController,
            itemBuilder: (context, index, dynamic item) {
              return ListTile(
                title: Text(item['title']),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    listViewController.dispose();
    super.dispose();
  }
}
```

