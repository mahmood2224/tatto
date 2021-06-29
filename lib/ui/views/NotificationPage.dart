import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tato/data/api_provider.dart';
import 'package:tato/data/model/sent/notification_response.dart';
import 'package:tato/ui/widgets/Loading.dart';
import 'package:tato/ui/widgets/app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tato/utils/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationPage extends StatefulWidget {

  @override
  _NotificationPageState createState() {
    return _NotificationPageState();
  }
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel> notifications = [] ;
  bool _loading = false ;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    _getNotification();
  }

  _getNotification (){
    setState(() =>_loading = false );
    ApiProvider.getNotification(onSuccess: (notifications){
      _refreshController.refreshCompleted();
      setState(() {
        this._loading = false ;
        this.notifications = notifications ;
      });
    }, onError: ()=>setState(() =>_loading = false ));
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
              Text("notification".tr(), style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500 , color: Colors.black),),
            ],
          ),
        ),
      ),
      body: Container(
        width: width,
          height: height,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: _loading ? Loading() :SmartRefresher(
          onRefresh: _getNotification,
          enablePullDown: true,
          controller: _refreshController,
          child: ListView.builder(
            itemCount: this.notifications?.length??0,
            itemBuilder: (context , index){
              NotificationModel notification = this.notifications[index] ;
              return Container(
                width: width-32,
                margin:EdgeInsets.symmetric(vertical: 16) ,
                  padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset("assets/icons/notification.svg" , color: PRIMARY_COLOR , width: 25, height: 25,),
                    SizedBox(width: 16,),
                    Container(
                      width: width-16-32-32-25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${notification?.title??""}" , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold ,color: PRIMARY_COLOR),),

                          Text("${notification?.created_at?.split(" ")[0]??""}" , style: TextStyle(fontSize: 12 , fontWeight: FontWeight.bold ,color: Colors.black),),

                          Text("${notification?.description??""}" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w500 ,color: Colors.black45),),
                        ],
                      ),
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