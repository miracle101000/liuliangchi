// import 'dart:async';
// import 'package:liuliangchi/config/common_config.dart';
// import 'package:liuliangchi/provider/app_provider.dart';
// import 'package:liuliangchi/util/common_util.dart';
// import 'package:liuliangchi/util/http.dart';
// import 'package:liuliangchi/util/paixs_fun.dart';
// import 'package:liuliangchi/view/views.dart';
// import 'package:flutter/material.dart';
// import 'package:liuliangchi/provider/provider_config.dart';
// import 'package:paixs_utils/model/data_model.dart';
// import 'package:paixs_utils/widget/anima_switch_widget.dart';
// import 'package:paixs_utils/widget/mylistview.dart';
// import 'package:paixs_utils/widget/paixs_widget.dart';
// import 'package:paixs_utils/widget/route.dart';
// import 'package:paixs_utils/widget/scaffold_widget.dart';
// import 'package:paixs_utils/widget/views.dart';
// import 'package:paixs_utils/widget/widget_tap.dart';
// import 'package:provider/provider.dart';

// class GonggaoItem extends StatefulWidget {
//   @override
//   _GonggaoItemState createState() => _GonggaoItemState();
// }

// class _GonggaoItemState extends State<GonggaoItem> with AutomaticKeepAliveClientMixin {
//   PageController pageCon = PageController();

//   Timer timer;

//   @override
//   void initState() {
//     this.initData();
//     super.initState();
//   }

//   ///初始化函数
//   Future initData() async {
//     await app.noticeUserTop();
//     setState(() {});
//     if (app.xiaoxiTopDm.list.isNotEmpty) {
//       timer = Timer.periodic(Duration(seconds: 2), (t) {
//         if (pageCon?.page?.toInt() == app.xiaoxiTopDm.list.length - 1) {
//           pageCon?.jumpToPage(0);
//         } else {
//           pageCon?.animateToPage(
//             pageCon.page.toInt() + 1,
//             duration: Duration(milliseconds: 500),
//             curve: Curves.easeOutCubic,
//           );
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Selector<AppProvider, int>(
//       selector: (_, k) => k.xiaoxiTopDm.flag,
//       builder: (_, v, view) {
//         return AnimatedSwitchBuilder(
//           value: app.xiaoxiTopDm,
//           errorOnTap: () async {
//             await app.noticeUserTop();
//             setState(() {});
//           },
//           isAnimatedSize: true,
//           initialState: PWidget.boxh(0),
//           noDataView: PWidget.boxh(0),
//           errorView: PWidget.boxh(0),
//           listBuilder: (list, p, h) {
//             return PWidget.container(
//               PWidget.row([
//                 // PWidget.text('公告', [aColor, 16]),
//                 PWidget.container(
//                   PWidget.text('新闻', [pColor, 10]),
//                   {'bd': PFun.bdAllLg(pColor), 'br': 4, 'pd': PFun.lg(2, 2, 4, 4)},
//                 ),
//                 PWidget.boxw(8),
//                 Expanded(
//                   child: Container(
//                     height: 40,
//                     child: PageView.builder(
//                       itemCount: list.length,
//                       controller: pageCon,
//                       physics: NeverScrollableScrollPhysics(),
//                       scrollDirection: Axis.vertical,
//                       itemBuilder: (_, i) {
//                         return WidgetTap(
//                           onTap: () => jumpPage(TongzhiChild()),
//                           child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: PWidget.text(
//                               list[i]['title'],
//                               [aColor.withOpacity(0.75), 13],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 rightJtView(),
//               ]),
//               [double.infinity, null, Colors.white],
//               {'pd': PFun.lg(0, 0, 8, 8), 'br': 8},
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }

// ///通知页面
// class TongzhiChild extends StatefulWidget {
//   @override
//   _TongzhiChildState createState() => _TongzhiChildState();
// }

// class _TongzhiChildState extends State<TongzhiChild> {
//   @override
//   void initState() {
//     this.initData();
//     super.initState();
//   }

//   ///初始化函数
//   Future initData() async {
//     await this.getTongzhiChildList(isRef: true);
//   }

//   ///获取社区子组件内容
//   var tongzhiChildDm = DataModel(hasNext: false);
//   Future<int> getTongzhiChildList({int page = 1, bool isRef = false}) async {
//     await Request.post(
//       '/app/common/getNoticeList?page=$page',
//       data: {},
//       catchError: (v) => tongzhiChildDm.toError(v),
//       success: (v) => tongzhiChildDm.addList(v['result']['data'], isRef, v['result']['totalRows']),
//     );
//     setState(() {});
//     return tongzhiChildDm.flag;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldWidget(
//       appBar: buildTitle(context, title: '通知列表', isWhiteBg: true),
//       bgColor: Colors.white,
//       body: AnimatedSwitchBuilder(
//         value: tongzhiChildDm,
//         errorOnTap: () => this.getTongzhiChildList(isRef: true),
//         listBuilder: (list, p, h) {
//           return MyListView(
//             isShuaxin: true,
//             isGengduo: h,
//             onRefresh: () => this.getTongzhiChildList(isRef: true),
//             onLoading: () => this.getTongzhiChildList(page: p),
//             animationType: AnimationType.vertical,
//             listViewType: ListViewType.Separated,
//             itemCount: list.length,
//             divider: Divider(height: 0),
//             item: (i) {
//               return PWidget.container(
//                 PWidget.row([
//                   if (isNotNull(list[i]['cover'])) PWidget.wrapperImage(list[i]['cover'], [120, 80], {'br': 4}),
//                   if (isNotNull(list[i]['cover'])) PWidget.boxw(10),
//                   PWidget.column(
//                     [
//                       PWidget.text(list[i]['title'], [aColor.withOpacity(0.75), 15], {'max': 2}),
//                       PWidget.spacer(),
//                       // PWidget.text('${list[i]['content']}', [aColor.withOpacity(0.5), 13], {'exp': true}),
//                       PWidget.text('${list[i]['showDate']}', [aColor.withOpacity(0.5), 13]),
//                     ],
//                     {'exp': 1},
//                   ),
//                 ], {
//                   'fill': true
//                 }),
//                 {
//                   'pd': 10,
//                   'fun': () => jumpPage(TongzhiChildInfo(list[i])),
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// ///通知详情
// class TongzhiChildInfo extends StatefulWidget {
//   final Map data;
//   const TongzhiChildInfo(this.data, {Key key}) : super(key: key);
//   @override
//   _TongzhiChildInfoState createState() => _TongzhiChildInfoState();
// }

// class _TongzhiChildInfoState extends State<TongzhiChildInfo> {
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldWidget(
//       appBar: buildTitle(context, title: '通知详情', isWhiteBg: true, rigthWidget: PWidget.icon(Icons.share, {'pd': 8}), rightCallback: () {}, isShowBorder: true),
//       bgColor: Colors.white,
//       body: MyListView(
//         isShuaxin: false,
//         flag: false,
//         item: (i) => item[i],
//         itemCount: item.length,
//         padding: EdgeInsets.all(10),
//         listViewType: ListViewType.Separated,
//         divider: Divider(color: Colors.transparent, height: 10),
//       ),
//     );
//   }

//   List<Widget> get item {
//     return [
//       PWidget.text(widget.data['title'], [aColor, 16], {'isOf': false}),
//       PWidget.text('发布时间：${widget.data['showDate']}', [aColor.withOpacity(0.25), 12]),
//       Divider(height: 0),
//       htmlView(widget.data['content']),
//     ];
//   }
// }
