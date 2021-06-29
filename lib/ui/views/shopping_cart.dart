import 'dart:convert';

import 'package:tato/data/model/sent/orders_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tato/data/api_provider.dart';
import 'package:tato/data/model/sent/counts_model.dart';
import 'package:tato/data/model/sent/make_order.dart';
import 'package:tato/data/model/sent/orders_model.dart';
import 'package:tato/data/model/sent/products_model.dart';
import 'package:tato/ui/views/end_order.dart';
import 'package:tato/ui/views/item_cart.dart';
import 'package:tato/ui/views/order_detilse.dart';
import 'package:tato/ui/widgets/Loading.dart';
import 'package:tato/ui/widgets/app_bar.dart';
import 'package:tato/ui/widgets/button_nav.dart';
import 'package:tato/utils/colors.dart';

class ShoppingCart extends StatefulWidget {
  Function onSuccess;

  ShoppingCart({this.onSuccess});

  @override
  _ShoppingCartState createState() {
    return _ShoppingCartState();
  }
}

class _ShoppingCartState extends State<ShoppingCart> {
  bool _loading = false;
  bool _buttonLoading = false;
  bool _orderLoading = false;

  TextEditingController _code = new TextEditingController();

  String errorMsg = "";
  String domain = "";
  List<Product> dishes = [];
  double totalPrice = 0;
  bool _countsLoading = false;
  int discountPercent = 0 ;
  double productsPrice = 0 ;
  double discount = 0 ;
  Count counts ;


  @override
  void initState() {
    super.initState();
    _getAllCart();
  }


  _getDiscount() async {
    MakeOrderModel data = await getFromLocal() ;
    ApiProvider.getDiscountFromServer(productsPrice, (data?.orderType??0) ,onSuccess: (discount){
      this.discountPercent = discount ;
      setState(() {
        this._countsLoading = false;
      });
      _culcPrice();
    });
  }

  _culcPrice(){
    this.discount = productsPrice * discountPercent / 100 ;
    print("discount : $discount");
    totalPrice = productsPrice - discount ;
    setState((){});
  }

  _getAllCart() {
    setState(() => _loading = true);
    ApiProvider.getCart(onSuccess: (dishs) {
      setState(() {
        this._loading = false;
        this.dishes = dishs;
      });
      _getCounts();
    }, onError: () {
      setState(() => _loading = false);
    });
  }

  _addToCart(int productId, int qty) {
    ApiProvider.addToCart(
        productId: "$productId",
        qty: qty,
        onSuccess: (message , count ) {
          showToast(message, backgroundColor: Colors.green);
          setState(() => this.productsPrice = double.parse("${count.total_price}"));
          _culcPrice();
        },
        onError: (message) {
          showToast(message, backgroundColor: Colors.red);
          setState(() => _countsLoading = false);
        });
  }

  _removeToCart(int productId) {
    ApiProvider.removeFromCart(
        productId: "$productId",
        onSuccess: (message , count ) {
          showToast(message, backgroundColor: Colors.green);
          setState(() => this.productsPrice = double.parse("${count.total_price}"));
          this.dishes.removeWhere((element) => element.id == productId);
          _culcPrice();
        },
        onError: () {
          setState(() => _countsLoading = false);
        });
  }

  _getCounts() {
    setState(() => _countsLoading = true);
    ApiProvider.getCounts(
        onError: () => setState(() => _countsLoading = false),
        onSuccess: (count) {
          setState(() {
            this.productsPrice = double.parse("${count.total_price}");
            this.counts = count ;
          });
          _getDiscount();
        });
  }


  // _saveOrderNotes(){
  //   setState(() => _buttonLoading = true);
  //   List<CartNoteModel> productsNotes = this.dishes.map((e) => CartNoteModel(cartProductId: e.id  ,note: e?.note??"")).toList();
  //   ApiProvider.addNotesToCart(products: productsNotes , onSuccess: (msg){
  //     setState(() {
  //       _buttonLoading = false ;
  //     });
  //     _next();
  //   } , onError: (msg)=>setState(()=>_buttonLoading = false));
  // }
  _next ()async{

    MakeOrderModel data = await getFromLocal() ;
    print("order Type : ${data.orderType}");
    if((data?.orderType??PLACE) != PLACE){
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => OrderDetilse(
              totalPrice: this.productsPrice,
              currency: counts?.currency,
            )),
      );
      return;
    }
    data.totalPrice = "${this.productsPrice}" ;
    data.discount = "${this.discount}";
    setState(()=>_orderLoading = true);
    ApiProvider.makeOrder(data: data , onSuccess: (msg , data){
      setState(() {
        this._orderLoading = false ;
      });
      showToast(msg,backgroundColor: Colors.green);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EndOrder(shppingPrice: 0 ,totalPrice: double.tryParse("${this.productsPrice}") , data: data, discount: discount , currency: counts.currency,), ));
    },onError: (error){
      setState(() {
        this._orderLoading = false ;
      });
      showToast(error , backgroundColor: Colors.red);
    });

  }

  _addNote(String note , int productId ){
    if(productId != null ) {
      int index = this.dishes.indexWhere((element) => element.id == productId);
      this.dishes[index].note = note;
    }
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
                "shopping_cart".tr(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.only( bottom: 80),
        child: _loading
            ? Loading()
            : SingleChildScrollView(
              child: ListView.builder(
                  itemCount: this.dishes?.length ?? 0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ItemCart(
                      this.dishes[index],
                      onQtyChanged: (qty, dish) => _addToCart(dish.id, qty),
                      onRemove: (id)=>_removeToCart(id),
                      onNote: (note , id)=> _addNote(note, id),
                    );
                  }),
            ),
      ),
      bottomSheet: SpedoButtonNav(
          text: "total".tr(),
          right: 16,
          smtext: "$productsPrice ",
          cr: counts?.currency??"cr".tr(),
          loading: _countsLoading,
          discount: "${this.discount}",
          buttonLoading: _orderLoading,
          buttonSt: "send_order".tr(),
          press: () {
            if(this.dishes.isEmpty)
              showToast("لا يوجد اي منتجات" , backgroundColor: Colors.red);
            else
              _next();
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
