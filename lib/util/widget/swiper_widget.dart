import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:paixs_utils/widget/custom_scroll_physics.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/photo_widget.dart';
import 'package:paixs_utils/widget/route.dart';

import '../paxis_fun.dart';

///轮播图小组件
class SwiperWidget extends StatefulWidget {
  final double? height;
  final List<dynamic>? imageList;

  const SwiperWidget({Key? key, this.height, this.imageList}) : super(key: key);
  @override
  _SwiperWidgetState createState() => _SwiperWidgetState();
}

class _SwiperWidgetState extends State<SwiperWidget> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 200,
      child: Stack(
        children: [
          StreamBuilder(builder: (context, v) {
            return Swiper(
              autoplay: !true,
              onIndexChanged: (i) => setState(() => index = i),
              autoplayDelay: 5000,
              curve: Curves.easeOutCubic,
              duration: 500,
              // pagination: SwiperPagination(
              //   builder: DotSwiperPaginationBuilder(
              //     size: 6,
              //     activeSize: 8,
              //     color: Colors.white,
              //     activeColor: Theme.of(context).primaryColor,
              //   ),
              // ),
              itemCount: widget.imageList!.length,
              physics: PagePhysics(),
              onTap: (i) => jumpPage(
                PhotoView(images: widget.imageList!, index: i),
              ),
              itemBuilder: (_, i) {
                // return SwiperImageWidget(imageList: widget.imageList, i: i);
                return PWidget.wrapperImage(
                  widget.imageList![i],
                  [double.infinity, 200],
                  {'w': 500},
                );
              },
            );
          }),
          PWidget.positioned(
            PWidget.container(
              PWidget.text(
                  '${index + 1}/${widget.imageList!.length}', [Colors.white]),
              [null, null, Colors.black26],
              {
                'br': 56,
                'pd': PFun.lg(2, 2, 12, 12),
              },
            ),
            [null, 12, null, 12],
          ),
        ],
      ),
    );
  }
}

class SwiperImageWidget extends StatefulWidget {
  final List<dynamic>? imageList;
  final int? i;

  const SwiperImageWidget({Key? key, this.imageList, this.i}) : super(key: key);

  @override
  _SwiperImageWidgetState createState() => _SwiperImageWidgetState();
}

class _SwiperImageWidgetState extends State<SwiperImageWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PWidget.wrapperImage(
      widget.imageList![widget.i!],
      [double.infinity, 200],
      {'w': 500},
    );
  }

  @override
  bool get wantKeepAlive => true;
}
