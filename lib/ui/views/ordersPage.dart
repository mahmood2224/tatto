import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tato/data/api_provider.dart';
import 'package:tato/data/model/sent/notification_response.dart';
import 'package:tato/data/model/sent/orders_model.dart';
import 'package:tato/ui/widgets/Loading.dart';
import 'package:tato/ui/widgets/app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tato/utils/algorithms.dart';
import 'package:tato/utils/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class OrdersPage extends StatefulWidget {

  @override
  _OrdersPageState createState() {
    return _OrdersPageState();
  }
}

class _OrdersPageState extends State<OrdersPage> {
  bool _loading = false ;
  List<Order> orders = []  ;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _getOrders();
  }

  _getOrders(){
    setState(() =>_loading = true);
    ApiProvider.getOrders(onError: ()=>setState(()=>_loading = false ) , onSuccess: (orders){
      setState(() {
        this.orders = orders ;
        this._loading = false ;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: SpedoAppBar(context,

        titleWidget: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("orders".tr(), style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500 , color: Colors.black),),
            ],
          ),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: _loading ? Loading() :SmartRefresher(
          enablePullDown: true,
          onRefresh: _getOrders,
          controller: _refreshController,
          child: ListView.builder(
            itemCount: this.orders?.length??0,
            itemBuilder: (context , index){
              Order order = this.orders[index];
              return Container(
                  width: width-32,
                  margin:EdgeInsets.symmetric(vertical: 16) ,
                  padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("# ${order?.id??0}" , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold , color: PRIMARY_COLOR),),
                          Text("${order?.created_at?.split(" ")[0]??""}" , style: TextStyle(fontSize: 16  , color: Colors.black45),),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Container( height: 1, width: width-32, color: Colors.black12,),
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Spacer(),
                          Column(
                            children: [
                              Text("total_price".tr() , style: TextStyle(fontSize: 16 , color: Colors.black45),),
                              Row(
                                children: [
                                  Text(convertNumbersString("${(order?.total_price??0) + (order?.shipping_price??0) - (order.discount??0)}") +" " , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.w500 , color: Colors.black),),
                                  Text(order?.currency??"cr".tr() , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.w500 , color: Colors.black45),),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(margin: EdgeInsets.symmetric(horizontal: 16), height: 30, width: 1, color: Colors.black12,),
                          Spacer(),
                          Column(
                            children: [
                              Text("status".tr() , style: TextStyle(fontSize: 16 , color: Colors.black45),),
                              Text("${getOrderStatusString(order?.status??1)}" , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold , color: getOrderStatusColor(order?.status??1)),),
                            ],
                          ),
                          Spacer(),

                        ],
                      )
                    ],
                  )
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}