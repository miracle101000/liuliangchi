import 'package:liuliangchi/util/provider/customer_provider.dart';
import 'package:liuliangchi/util/provider/shoping_pro.dart';
import 'package:liuliangchi/util/provider/shouyi_pro.dart';
import 'package:liuliangchi/util/provider/user_provider.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'app_provider.dart';
import 'gouwuche_provider.dart';
import 'home_pro.dart';
import 'lianghua_provider.dart';

///Porviders集
List<SingleChildWidget> pros = <SingleChildWidget>[
  ChangeNotifierProvider.value(value: UserProvider()),
  ChangeNotifierProvider.value(value: AppProvider()),
  ChangeNotifierProvider.value(value: HomePro()),
  ChangeNotifierProvider.value(value: ShopingPro()),
  ChangeNotifierProvider.value(value: LianghuaPro()),
  ChangeNotifierProvider.value(value: ShouyiPro()),
  ChangeNotifierProvider.value(value: GouwucheProvider()),
  ChangeNotifierProvider.value(value: CustomerProvider()),
];

/***
 * 各个Provider的快速封装
 */

///用户Provider
UserProvider get userPro => Provider.of<UserProvider>(context, listen: false);

///用户信息
Map get user => userPro.userModel!;

///app全局Provider
AppProvider get app => Provider.of<AppProvider>(context, listen: false);

///home全局Provider
HomePro get home => Provider.of<HomePro>(context, listen: false);

///ahome全局Provider
ShopingPro get shoping => Provider.of<ShopingPro>(context, listen: false);

///ahome全局Provider
LianghuaPro get lhPro => Provider.of<LianghuaPro>(context, listen: false);

///收益全局Provider
ShouyiPro get shouyi => Provider.of<ShouyiPro>(context, listen: false);

///收益全局Provider
GouwucheProvider get gouwuche =>
    Provider.of<GouwucheProvider>(context, listen: false);

///收益全局Provider
CustomerProvider get customerPro =>
    Provider.of<CustomerProvider>(context, listen: false);
