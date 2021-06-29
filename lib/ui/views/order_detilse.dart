import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tato/data/api_provider.dart';
import 'package:tato/data/model/sent/make_order.dart';
import 'package:tato/data/model/sent/orders_model.dart';
import 'package:tato/data/model/sent/zone_model.dart';
import 'package:tato/ui/views/end_order.dart';
import 'package:tato/ui/widgets/app_bar.dart';
import 'package:tato/ui/widgets/button_nav.dart';
import 'package:tato/ui/widgets/custom_switch.dart';
import 'package:tato/ui/widgets/spedo_text_field.dart';
import 'package:tato/utils/algorithms.dart';
import 'package:tato/utils/colors.dart';

class OrderDetilse extends StatefulWidget {

  double totalPrice ;
  String currency ; 

  OrderDetilse({this.totalPrice , this.currency});

  @override
  _OrderDetilseState createState() {
    return _OrderDetilseState();
  }
}



class OrderType {
  String name ;
  int value ;

  OrderType({this.name, this.value});
}

class _OrderDetilseState extends State<OrderDetilse> {

  bool _loading = false ;

  List<Zone > zones = [] ;
  List<OrderType> orderTypes =[OrderType(name: "توصيل" , value: DELIVERY) ,  OrderType(name: "سفري" , value: COLLECTION)];

  TextEditingController _name = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _address = new TextEditingController();

  Zone zone ;

  bool locationValue = false ;
  MakeOrderModel data = new MakeOrderModel() ;

  int _selectedOrderType = 0 ;

  int discountPercent = 0 ;

  double discount = 0.0 ;
  double totalPrice ;
  double originalPrice ;
  double shippingPrice ;
  @override
  void initState()  {
    super.initState();
    _initData() ;
  }



  _getDiscount(){
    ApiProvider.getDiscountFromServer(widget.totalPrice ,_selectedOrderType ,onSuccess: (discount){
      setState(()=>discountPercent = discount);
      _calcuPrices();
    });
  }
  _initData() async {
    data = await getFromLocal();
    _name.text = data?.name??"";
    _phone.text = data?.userPhone??"";
    _address.text = data?.address??"";

    print("order type : ${data?.orderType} \n shipping price : ${data.shippingPrice}");
    setState((){
      _selectedOrderType = data?.orderType ;
      shippingPrice = data?.shippingPrice ;
    }) ;
    _getDiscount();
    _calcuPrices();
  }

  // Future<void> getChangeLocationData() async {
  //   print("getting location data ");
  //   PermissionStatus permission = await LocationPermissions().checkPermissionStatus();
  //   print("location Permission Status is : $permission");
  //   if(permission != PermissionStatus.granted){
  //     await LocationPermissions().requestPermissions();
  //   }
  //   ServiceStatus serviceStatus = await LocationPermissions().checkServiceStatus();
  //   print("loacation Service Status is : $serviceStatus");
  //   if(serviceStatus != ServiceStatus.enabled){
  //     await LocationPermissions().openAppSettings();
  //   }
  //   Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
  //   double lat = position?.latitude ;
  //   double lng = position?.longitude;
  //   print("lat : $lat \n lng : $lng");
  //   if(this.data == null ) this.data = new MakeOrderModel();
  //   this.data.lat = "$lat";
  //   this.data.lng = "$lng";
  // }

  _makeOrder(){
    if(this.data == null ) this.data = new MakeOrderModel();
    this.data.userPhone = this._phone.text ;
    this.data.address = _selectedOrderType == DELIVERY ? this._address.text : null  ;
    this.data.name = this._name.text ;
    this.data.totalPrice ="${widget.totalPrice}" ;
    if(_selectedOrderType == COLLECTION ) {
      this.data.lat = null ;
      this.data.lng= null ;
    }
    this.data.discount = "${this.discount}" ;

    setState(()=>_loading = true);
    ApiProvider.makeOrder(data: data , onError: (error){
      setState(() =>_loading = false);
      showToast(error , backgroundColor: Colors.red);
    }, onSuccess: (msg  , id ){
      saveToLocal(this.data);
      setState(()=>_loading = false );
      showToast(msg , backgroundColor: Colors.green);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EndOrder(discount: this.discount,totalPrice: (widget.totalPrice) , shppingPrice: shippingPrice, id: int.tryParse("${id??0}") , currency: widget.currency,)), );
    });
  }

  _calcuPrices(){
   setState(() {
     totalPrice =  (widget.totalPrice??0) + shippingPrice ;
     discount =   (widget.totalPrice*this.discountPercent /100) ;
     originalPrice = totalPrice - discount ;
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
              Text("order_details".tr(), style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500 , color: Colors.black),),

            ],
          ),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 11,vertical: 8 ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                width: width-22,
                decoration: BoxDecoration(
                    color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("send_order_now".tr(), style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16 , color: PRIMARY_COLOR),),
                            Text("please_enter".tr(), style: TextStyle(fontWeight: FontWeight.w500 , fontSize: 12 , color: TEXT_COLOR100),),
                            Text("please_enter_info".tr(), style: TextStyle(fontWeight: FontWeight.w500 , fontSize: 12 , color: TEXT_COLOR100),)
                          ],
                        ),
                        Image.asset('assets/images/DeliveryBike.png' ,width: 80, height: 80,)
                      ],
                    ),
                    SizedBox(height: 13,),
                    SpedoTextField(
                      width: width-22-40,
                      height: 42,
                      backgroundColor: INPUT_BACKGROUND,
                      hint: "name".tr(),
                      controller: _name,
                    ),
                    SizedBox(height: 13,),
                    SpedoTextField(
                      width: width-22-40,
                      height: 42,
                      backgroundColor: INPUT_BACKGROUND,
                      hint: "phone".tr(),
                      controller: _phone,
                      textType: TextInputType.number,
                    ),
                    _selectedOrderType != DELIVERY ? Container(): SizedBox(height: 13,),
                    _selectedOrderType != DELIVERY ? Container():SpedoTextField(
                      width: width-22-40,
                      height: 88,
                      backgroundColor: INPUT_BACKGROUND,
                      hint: "near_point".tr(),
                      controller: _address,
                    ),
                    // _selectedOrderType != DELIVERY ? Container():  SizedBox(height: 10,),
                    // _selectedOrderType != DELIVERY ?  Container() : Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text("select_location".tr(), style: TextStyle(fontWeight: FontWeight.bold , fontSize: 12 , color: PRIMARY_COLOR),),
                    //         Text("send_location".tr(), style: TextStyle(fontWeight: FontWeight.w500 , fontSize: 10 , color: TEXT_COLOR100),)
                    //       ],
                    //     ),
                    //     CustomSwitch(
                    //       activeColor: PRIMARY_COLOR,
                    //       value: locationValue,
                    //       onChanged: (value) {
                    //         print("VALUE : $value");
                    //         setState(() {
                    //           locationValue = value;
                    //         });
                    //         if(value){
                    //           this.getChangeLocationData();
                    //         }else{
                    //           this.data.lat = null ;
                    //           this.data.lng = null ;
                    //         }
                    //       },
                    //     )
                    //   ],
                    // ),

                  ],
                ),
              ),
              SizedBox(height: 8,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                width: width-22,
                height: 132+24.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("total".tr(), style: TextStyle( fontSize: 11 , color: TEXT_COLOR100),),
                        Container(
                          child: Row(
                            children: [
                              Text(convertNumbersString("${widget.totalPrice??0}")+" ", style: TextStyle( fontSize: 15 , color: TEXT_COLOR , fontWeight: FontWeight.w500),),
                              Text(widget.currency??"cr".tr(), style: TextStyle( fontSize: 13 , color: TEXT_COLOR100),)
                            ],
                          ),
                        ),
                      ],

                    ),
                    SizedBox(height: 4,),
                    Container(
                      height: 1,
                      color: Color(0xffF5F5F5),
                    ),
                    SizedBox(height: 4,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("sipping".tr(), style: TextStyle( fontSize: 11 , color: TEXT_COLOR100),),
                        Container(
                          child: Row(
                            children: [
                              Text(convertNumbersString("$shippingPrice")+" ", style: TextStyle( fontSize: 15 , color: TEXT_COLOR , fontWeight: FontWeight.w500),),
                              Text(widget.currency??"cr".tr(), style: TextStyle( fontSize: 13 , color: TEXT_COLOR100),)
                            ],
                          ),
                        ),
                      ],

                    ),
                    SizedBox(height: 4,),
                    Container(
                      height: 1,
                      color: Color(0xffF5F5F5),
                    ),
                    SizedBox(height: 4,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("الخصم  ($discountPercent%)".tr(), style: TextStyle( fontSize: 11 , color: PRIMARY_COLOR),),
                        Container(
                          child: Row(
                            children: [
                              Text(convertNumbersString("$discount") + " ", style: TextStyle( fontSize: 15 , color: PRIMARY_COLOR , fontWeight: FontWeight.w500),),
                              Text(widget.currency??"cr".tr(), style: TextStyle( fontSize: 13 , color: PRIMARY_COLOR),)
                            ],
                          ),
                        ),
                      ],

                    ),
                    Container(
                      height: 1,
                      color: Color(0xffF5F5F5),
                    ),
                    SizedBox(height: 4,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("total_price".tr(), style: TextStyle( fontSize: 11 , color: TEXT_COLOR100),),
                        Container(
                          child: Row(
                            children: [
                              Text(convertNumbersString("$originalPrice") +" ", style: TextStyle( fontSize: 15 , color: TEXT_COLOR , fontWeight: FontWeight.w500),),
                              Text(widget.currency??"cr".tr(), style: TextStyle( fontSize: 13 , color: TEXT_COLOR100),)
                            ],
                          ),
                        ),
                      ],

                    ),
                    SizedBox(height: 4,),
                    Container(
                      height: 1,
                      color: Color(0xffF5F5F5),
                    ),



                  ],
                ),
              ),
              SizedBox(height: 100,),
            ],

          ),
        ),



      ),
      bottomSheet: SpedoButtonNav(
          text: "total".tr(),
          right: 16,
          smtext: "$originalPrice",
          cr: widget.currency??"cr".tr(),
          buttonSt: "finish_order".tr(),
          press:_makeOrder,
          buttonLoading: _loading,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );

  }

  @override
  void dispose() {
    super.dispose();
  }
}