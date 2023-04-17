import 'package:flutter/material.dart';
import 'package:paixs_utils/widget/custom_scroll_physics.dart';
import 'package:paixs_utils/widget/my_bouncing_scroll_physics.dart';

class TabWidget extends StatefulWidget {
  final List<String>? tabList;
  final List<Widget>? tabPage;
  final bool? isScrollable;
  final ScrollPhysics? pagePhysics;
  final int? page;
  final Color? color;

  const TabWidget(
      {Key? key,
      this.tabList,
      this.tabPage,
      this.isScrollable,
      this.pagePhysics,
      this.page = 0,
      this.color})
      : super(key: key);
  @override
  _TabWidgetState createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> with TickerProviderStateMixin {
  TabController? tabCon;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    tabCon = TabController(
        vsync: this,
        length: widget.tabList!.length,
        initialIndex: widget.page!);
  }

  @override
  void dispose() {
    tabCon?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: TabBarView(
            physics: widget.pagePhysics ??
                PagePhysics(parent: MyBouncingScrollPhysics()),
            controller: tabCon,
            children: widget.tabPage!,
          ),
        ),
        Container(
          height: 40,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.color ?? Colors.white,
            // border: Border(
            //   bottom: BorderSide(color: Colors.black.withOpacity(0.05)),
            // ),
          ),
          child: TabBar(
            controller: tabCon,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            // indicatorPadding: EdgeInsets.symmetric(horizontal: 8),
            isScrollable: widget.isScrollable ?? true,
            indicatorColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black.withOpacity(0.7),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            labelColor: Theme.of(context).primaryColor,
            tabs: widget.tabList!.map((m) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Tab(text: m),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
