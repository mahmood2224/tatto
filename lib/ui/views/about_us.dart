import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:tato/data/api_provider.dart';
import 'package:tato/data/model/sent/about_us.dart';
import 'package:tato/data/model/sent/counts_model.dart';
import 'package:tato/ui/views/shopping_cart.dart';
import 'package:tato/ui/widgets/Loading.dart';
import 'package:tato/ui/widgets/app_bar.dart';
import 'package:tato/ui/widgets/button_nav.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tato/utils/algorithms.dart';

class AboutUsPage extends StatefulWidget {

  @override
  _AboutUsPageState createState() {
    return _AboutUsPageState();
  }
}

class _AboutUsPageState extends State<AboutUsPage> {
  bool _loading = false ;
  bool _countsLoading = false ;
  AboutUsModel response ;
  Count _counts ;
  @override
  void initState() {
    super.initState();
    _getCounts();
    _getdata();
  }

  _getCounts() {
    setState(() => _countsLoading = true);
    ApiProvider.getCounts(
        onError: () => setState(() => _countsLoading = false),
        onSuccess: (count) {
          this._counts = count ;
          setState(() =>this._countsLoading =false );
        });
  }

  _getdata() {
    setState(() => _loading = true);
    ApiProvider.getAboutUs(
        onError: () => setState(() => _loading = false),
        onSuccess: (aboutUs) {
          this.response = aboutUs ;
          setState(() =>this._loading =false );
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: SpedoAppBar(context,
            getCounts: _getCounts,
            counts: this._counts , title: "من نحن"),
      body: Container(
        height:height,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
        child: _loading ? Loading():SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Html(
            data: """
                  ${response?.about_us??""}
                """,
            onLinkTap: (url) {
              print("Opening $url...");
            },
          ),
              SizedBox(height: 16,),
              InkWell(
                onTap: ()=>launchURL("tel://${response?.phone_number??""}"),
                child: Text(
                  "${response?.phone_number??""}" ,
                  style: TextStyle(fontSize: 16 , color: Colors.blue , fontWeight: FontWeight.bold , decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ),
        bottomSheet: SpedoButtonNav(
            text: "total".tr(),
            smtext: "${this._counts?.total_price ?? 0} ",
            cr:_counts?.currency??"cr".tr(),
            right:20 ,
            loading: _countsLoading,
            buttonSt: "finish_order".tr(),
            press: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ShoppingCart()),
              );
              _getCounts();
            })
    );
  }
}