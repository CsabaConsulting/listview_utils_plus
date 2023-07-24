import 'package:flutter/material.dart';
import 'package:listview_utils_plus/listview_utils_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      title: 'Example',
      home: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔌 ListView Utils+')),
      body: SafeArea(
        child: CustomListView(
          paginationMode: PaginationMode.page,
          initialOffset: 0,
          loadingBuilder: CustomListLoading.defaultBuilder,
          header: const SizedBox(
            height: 50,
            child: Center(
              child: Text('😄 Header'),
            ),
          ),
          footer: const SizedBox(
            height: 50,
            child: Center(
              child: Text('🦶 Footer'),
            ),
          ),
          adapter: const NetworkListAdapter(
            url: 'https://jsonplaceholder.typicode.com/posts',
            limitParam: '_limit',
            offsetParam: '_start',
          ),
          itemBuilder: (context, _, item) {
            return ListTile(
              title: Text(item['title']),
              leading: const Icon(Icons.assignment),
            );
          },
          errorBuilder: (context, error, state) {
            return Column(
              children: <Widget>[
                Text(error.toString()),
                TextButton(
                  onPressed: () => state.loadMore(),
                  child: const Text('Retry'),
                ),
              ],
            );
          },
          separatorBuilder: (context, _) {
            return const Divider(height: 1);
          },
          empty: const Center(
            child: Text('Empty'),
          ),
        ),
      ),
    );
  }
}
