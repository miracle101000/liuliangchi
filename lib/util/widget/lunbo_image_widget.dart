import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/custom_scroll_physics.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';

import '../provider/provider_config.dart';

class LunboImageWidget extends StatefulWidget {
  final int? plate;
  final double? height;
  final EdgeInsetsGeometry padding;
  const LunboImageWidget({
    Key? key,
    this.plate,
    this.height,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
  }) : super(key: key);
  @override
  _LunboImageWidgetState createState() => _LunboImageWidgetState();
}

class _LunboImageWidgetState extends State<LunboImageWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await Future.delayed(Duration(milliseconds: 500));
    await app.getRecommendImage(2);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedSwitchBuilder(
      value: app.shouyeLunboDm,
      // isRef: true,
      errorOnTap: () async {
        await app.getRecommendImage(2);
        setState(() {});
        return 0;
      },
      initialState: PWidget.boxh(0),
      noDataView: PWidget.boxh(0),
      errorView: PWidget.boxh(0),
      isAnimatedSize: true,
      listBuilder: (List<dynamic> list, _, __) {
        return Container(
          height: widget.height ?? 100,
          margin: widget.padding ?? EdgeInsets.zero,
          child: Swiper(
            autoplay: true,
            autoplayDelay: 10000,
            curve: Curves.easeOutCubic,
            duration: 500,
            // pagination: SwiperPagination(
            //   margin: EdgeInsets.only(bottom: 16),
            //   builder: DotSwiperPaginationBuilder(
            //     size: 6,
            //     activeSize: 8,
            //     color: Colors.white,
            //     activeColor: Theme.of(context).primaryColor,
            //   ),
            // ),
            itemCount: list.length,
            physics: PagePhysics(),
            itemBuilder: (_, i) {
              return PWidget.wrapperImage(
                list[i]['image'],
                [double.infinity, widget.height ?? 100],
                {
                  'br': 8,
                  'fun': () {
                    flog(list[i]);
                    switch ('${list[i]['linkType']}') {
                      case '1':
                        lunTelURL(list[i]['link']);
                        break;
                      case '2':
                        break;
                    }
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
