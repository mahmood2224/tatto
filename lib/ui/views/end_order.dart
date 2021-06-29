import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tato/ui/views/home.dart';
import 'package:tato/ui/views/product_gallary.dart';
import 'package:tato/ui/views/order_detilse.dart';
import 'package:tato/ui/widgets/app_bar.dart';
import 'package:tato/ui/widgets/button_nav.dart';
import 'package:tato/ui/widgets/spedo_button.dart';
import 'package:tato/utils/algorithms.dart';
import 'package:tato/utils/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EndOrder extends StatefulWidget {
  double totalPrice;
  double shppingPrice;
  double discount;
  int id;
  String data;
  String currency ; 

  EndOrder(
      {this.totalPrice, this.shppingPrice, this.id, this.data, this.discount , this.currency});

  @override
  _EndOrderState createState() {
    return _EndOrderState();
  }
}

class _EndOrderState extends State<EndOrder> {
  bool _loading = false;

  TextEditingController _code = new TextEditingController();

  String errorMsg = "";
  String domain = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: SpedoAppBar(
        context,
        titleWidget: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "thank_you".tr(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        leading: Container()
      ),
      body: Container(
        color: Colors.white,
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            ...widget.data == null ?[Image.asset("assets/images/DeliveryBike.png" , width: 100, height: 100,)] :[  SizedBox(
                height: 30,
              ),
              QrImage(
                data: widget.data,
                version: QrVersions.auto,
                size: 150,
                gapless: false,
              ),
              SizedBox(
                height: 16,
              ),],
              SizedBox(
                height: 35,
              ),
              Text(
                widget.data!= null ? "تم تنفيذ الطلب":"done_order".tr(),
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: PRIMARY_COLOR),
              ),
              SizedBox(
                height: 13,
              ),
              widget.data != null
                  ? Container()
                  : Text(
                      "success_order".tr(),
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: TEXT_COLOR100),
                    ),
              Text(
                widget.data != null
                    ? "من فضلك قم بمسح الكود للحصول علي معلومات الطلب"
                    : "success_ord".tr(),
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: TEXT_COLOR100),
                textAlign: TextAlign.center,
              ),
              Container(
                width: width / 2,
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                   widget.data != null ? Container() : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "order_number".tr(),
                          style: TextStyle(fontSize: 11, color: TEXT_COLOR100),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Text(
                                "# ${widget.id ?? 0} ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: TEXT_COLOR,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    widget.data != null ? Container() :  Container(
                      height: 1,
                      color: Color(0xffF5F5F5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "total".tr(),
                          style: TextStyle(fontSize: 11, color: TEXT_COLOR100),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Text(
                                convertNumbersString(
                                        "${widget.totalPrice ?? 0}") +
                                    "",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: TEXT_COLOR,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.currency??"cr".tr(),
                                style: TextStyle(
                                    fontSize: 13,
                                    color: TEXT_COLOR100,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: Color(0xffF5F5F5),
                    ),
                    widget.data != null ? Container() :  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "shipping".tr(),
                          style: TextStyle(fontSize: 11, color: TEXT_COLOR100),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Text(
                                convertNumbersString(
                                        "${widget.shppingPrice ?? 0} ") +
                                    " ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: TEXT_COLOR,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.currency??"cr".tr(),
                                style: TextStyle(
                                    fontSize: 13,
                                    color: TEXT_COLOR100,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    widget.data != null ? Container() :   Container(
                      height: 1,
                      color: Color(0xffF5F5F5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "الخصم".tr(),
                          style: TextStyle(fontSize: 11, color: TEXT_COLOR100),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Text(
                                "-" +
                                    convertNumbersString(
                                        "${widget.discount ?? 0} ") +
                                    " ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: TEXT_COLOR,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.currency??"cr".tr(),
                                style: TextStyle(
                                    fontSize: 13,
                                    color: TEXT_COLOR100,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: Color(0xffF5F5F5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "total_price".tr(),
                          style: TextStyle(fontSize: 11, color: TEXT_COLOR100),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Text(
                                convertNumbersString(
                                        "${(widget.totalPrice ?? 0) + (widget.shppingPrice ?? 0) - (widget.discount ?? 0)} ") +
                                    " ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: TEXT_COLOR,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.currency??"cr".tr(),
                                style: TextStyle(
                                    fontSize: 13,
                                    color: TEXT_COLOR100,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SpedoButton(
                text: "العودة للرئيسية",
                width: (width - 40) / 2,
                height: 40,
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Home()),(route)=>false
                ),

              ),
              SizedBox(
                height: 16,
              ),
            ],
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
