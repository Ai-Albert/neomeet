import 'package:digital_contact_card/app/helpers/empty_content.dart';
import 'package:flutter/material.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key? key,
    required this.snapshot,
    required this.itemBuilder,
    required this.width,
  }) : super(key: key);

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T>? items = snapshot.data;
      if (items!.isNotEmpty) {
        return _buildList(items);
      } else {
        return Container();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(child: CircularProgressIndicator(color: Colors.white));
  }

  Widget _buildList(List<T> items) {
    // Using ListView.separated instead of regular ListView makes it more efficient (builder is also like this)
    // builder only builds the items that are visible on screen instead of everything
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(width, 10, width, 0),
      itemCount: items.length,
      separatorBuilder: (context, index) => Divider(height: 10.0),
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index]);
      },
    );
  }
}
