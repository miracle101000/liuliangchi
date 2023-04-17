import 'package:flutter/material.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/my_bouncing_scroll_physics.dart';
import 'package:paixs_utils/widget/views.dart';

import 'my_scroll_physics.dart';

class MyNestedListView extends StatefulWidget {
  @override
  _MyNestedListViewState createState() => _MyNestedListViewState();
}

class _MyNestedListViewState extends State<MyNestedListView> {
  final _listViewController = ScrollController();
  final _listViewController1 = ScrollController();

  MyScrollPhysics physics = MyScrollPhysics(
      isProhibit: true, scrollPhysics: NeverScrollableScrollPhysics());
  // final _nestedScrollViewKey = GlobalKey();

  double get headerHeight => 1600;

  final GlobalKey<ScrollableState> _listKey = GlobalKey<ScrollableState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 2,
        controller: _listViewController1,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (_, i) {
          return [
            Container(
              height: headerHeight,
              color: Colors.red,
            ),
            Container(
              height: pmSize.height - 1,
              child: ListView.builder(
                itemCount: 100,
                key: _listKey,
                // physics: ClampingScrollPhysics(),
                physics: physics.scrollPhysics,
                // physics: NeverScrollableScrollPhysics(),
                controller: _listViewController,
                itemBuilder: (_, i) {
                  flog(i, 'itemBuilder');
                  return Container(
                    height: 112,
                    color: Colors.amber,
                    margin: EdgeInsets.all(24),
                  );
                },
              ),
            ),
          ][i];
        },
      ),
      // body: NestedScrollView(
      //   key: _nestedScrollViewKey,
      //   headerSliverBuilder: (context, innerBoxIsScrolled) {
      //     return [
      //       SliverAppBar(
      //         title: Text('Nested ListView Example'),
      //         pinned: true,
      //         expandedHeight: 200,
      //         flexibleSpace: FlexibleSpaceBar(
      //           background: Image.network(
      //             'https://picsum.photos/id/237/200/300',
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),
      //     ];
      //   },
      //   body: ListView.builder(
      //     controller: _listViewController,
      //     key: PageStorageKey<String>('myListView'),
      //     itemCount: 100,
      //     itemBuilder: (context, index) {
      //       return ListTile(
      //         title: Text('Item $index'),
      //       );
      //     },
      //   ),
      // ),
    );
  }

  @override
  void initState() {
    super.initState();
    _listViewController1.addListener(() {
      flog(_listViewController1.position.atEdge,
          '_listViewController1.position.atEdge');
      if (_listViewController1.offset > headerHeight - 1) {
        if (physics.isProhibit!)
          setState(() {
            physics = MyScrollPhysics(
              isProhibit: false,
              scrollPhysics: AlwaysScrollableScrollPhysics(),
            );
          });
      } else {
        if (!physics.isProhibit!)
          setState(() {
            physics = MyScrollPhysics(
              isProhibit: true,
              scrollPhysics: NeverScrollableScrollPhysics(),
            );
          });
      }
    });
    _listViewController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _listViewController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    flog(_listViewController.offset);
    if (_listViewController.offset <= 1) {
      if (!physics.isProhibit!)
        setState(() {
          physics = MyScrollPhysics(
            isProhibit: true,
            scrollPhysics: NeverScrollableScrollPhysics(),
          );
        });
    } else {
      if (physics.isProhibit!)
        setState(() {
          physics = MyScrollPhysics(
            isProhibit: false,
            scrollPhysics: AlwaysScrollableScrollPhysics(),
          );
        });
    }
    return;
    // if (_nestedScrollViewKey.currentState != null) {
    flog(_listViewController1.offset, '_listViewControlleroffset');
    if (_listViewController1.offset < headerHeight - 1) {
      flog('滑动');
      // _listViewController1.jumpTo(_listViewController.offset * 2);
      _listViewController.jumpTo(_listViewController.offset / 2);
    } else {
      if (_listViewController.position.extentBefore <= 0) {
        _listViewController1.jumpTo(-_listViewController.offset);
        // _listViewController1.animateTo(
        //   _listViewController.offset,
        //   duration: Duration(milliseconds: 250),
        //   curve: Curves.easeOutCubic,
        // );
      }
      flog('停止');
      // _listViewController1.jumpTo(112);
    }
    // _nestedScrollViewKey.currentState.outerController?.jumpTo(_listViewController.offset);
    // }
  }
}
