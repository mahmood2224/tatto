import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tato/data/api_provider.dart';
import 'package:tato/data/model/sent/category_model.dart';
import 'package:tato/data/model/sent/counts_model.dart';
import 'package:tato/data/model/sent/products_model.dart';
import 'package:tato/data/model/sent/types_model.dart';
import 'package:tato/ui/views/NotificationPage.dart';
import 'package:tato/ui/views/Product_widget.dart';
import 'package:tato/ui/views/cart_flying_item.dart';
import 'package:tato/ui/views/home.dart';
import 'package:tato/ui/views/ordersPage.dart';
import 'package:tato/ui/views/product_details.dart';
import 'package:tato/ui/views/shopping_cart.dart';
import 'package:tato/ui/widgets/Loading.dart';
import 'package:tato/ui/widgets/app_bar.dart';
import 'package:tato/ui/widgets/badge.dart';
import 'package:tato/ui/widgets/button_nav.dart';
import 'package:tato/ui/widgets/drawer.dart';
import 'package:tato/ui/widgets/filtter_componant.dart';
import 'package:tato/ui/widgets/type_dialog.dart';
import 'package:tato/utils/Dialog.dart';
import 'package:tato/utils/algorithms.dart';
import 'package:tato/utils/colors.dart';
import 'dart:math' as math;

import 'package:pull_to_refresh/pull_to_refresh.dart';

 const int LIST = 0;
 const int GRIDE = 1;


class ProductGallary extends StatefulWidget {
  int selectedType ;

  ProductGallary({this.selectedType = LIST});

  @override
  _ProductGallaryState createState() {
    return _ProductGallaryState();
  }
}
FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
class _ProductGallaryState extends State<ProductGallary> with SingleTickerProviderStateMixin {

  bool _loading = false;
  bool _countsloading = false;

  TextEditingController _code = new TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  String errorMsg = "";
  String domain = "";
  List<Product> product = [];
  List<Product> oldData = [];
  List<Product> unSearched = [];
  List<CategoryModel> categories = [];
  String title = "اختر الفئة";

  int _selectedType = LIST;
  String searchText = '' ;

  int _selectedCatIndex = 0;
  Count counts;
  TypesModel types ;

  Position fromPosition;

  AnimationController slideController;
  String flyingImage;

  double gridViewHeight;

  bool _addAgain = true ;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedType ;
    slideController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _getProducts();
    _getCounts();
    _getCategories();
    _getTypes();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage hi : $message");
      String title ="" ;
      String desc ="" ;
      if(Platform.isIOS){
        title = message.notification.title;
        desc = message.notification.body;
      }else{
        title = message.data['title'] ;
        desc = message.data['body'] ;
      }

      showAlertDialog(context , title: title , desc:desc);
    });
  }

  _getProducts({String searchTxt}) {
    _refreshController.refreshCompleted();
    setState(() => _loading = true);
    ApiProvider.getAllProducts(
        searchTxt: searchTxt,
        onError: () => setState(() => _loading = false),
        onSuccess: (dishes) {
          setState(() {
            this.product = dishes;
            this.oldData = product;
            this._loading = false;
          });
        });
  }

  _getCategories() {
    ApiProvider.getAllCategories(
        onError: () => setState(() => _loading = false),
        onSuccess: (categories) {
          setState(() {
            this.categories = categories;
          });
        });
  }

  _addToCart(String productId, {GlobalKey key, String image}) {
    if(!_addAgain ) return ;
    _addAgain = false ;
    setState(() {
      fromPosition = getPositionbyKey(key);
      this.flyingImage = image;
    });
    ApiProvider.addToCart(
        productId: productId,
        qty: 1,
        onSuccess: (message, count) {
          new Timer(Duration(milliseconds: 400), () {
            setState(() => this.counts = count);
            this._addAgain= true ;
          });
        },
        onError: (message) {
          showToast(message, backgroundColor: Colors.red);
          setState(() => _countsloading = false);
          this._addAgain= true ;
        });
  }

  _getCounts() {
    _addAgain = false ;
    setState(() => _countsloading = true);
    ApiProvider.getCounts(
        onError: () => setState(() => _countsloading = false),
        onSuccess: (count) {
          setState(() {
            this.counts = count;
            this._countsloading = false;
          });
          _addAgain = true ;
        });
  }

  _getTypes() {
    ApiProvider.getTypes(
        onError: () {},
        onSuccess: (types) {
          setState(() {
            this.types = types;
          });
        });
  }

  _showTypeDialog(String productId, {GlobalKey key, String image}) {
    ShowDialog(
        context: context,
        height: MediaQuery.of(context).size.height / 2.5,
        alignment: Alignment.center,
        radius: BorderRadius.circular(16),
        child: TypeDialog(this.types,onSuccess: ()=>_addToCart(productId , image: image , key: key),));
  }

 CategoryModel _getCategoryforProduct(Product product){
    print("product to check is : ${product?.name}      id : ${product?.id}" );
   try {
     CategoryModel category = this.categories.firstWhere((element) {
       print("element checking is : ${element.name}");
       for(int i = 0 ; i < (element?.dishes?.length??0) ; i++){
         print("product chicking is : ${element.dishes[i].name}   id : ${product?.id}");
         if( element.dishes[i].id == product.id ) return true ;
      }
       return false ;
    });
    return category ;
   }catch(e){
     return null ;
   }
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    gridViewHeight = 182;
    if(Platform.isIOS)gridViewHeight = 182 ;
    return Scaffold(
      key: _scaffoldKey,

      appBar: SpedoAppBar(context,
          getCounts: _getCounts,
          counts: this.counts,
          titleWidget: Container(
            child: InkWell(
              onTap: () => ShowDialog(
                  context: context,
                  alignment: Alignment.topCenter,
                  radius: BorderRadius.circular(15),
                  margin: EdgeInsets.symmetric(vertical: 34, horizontal: 62),
                  height: height / 1.5,
                  opacity: 0.2,
                  child: FiltterComponant(
                    this.categories,
                    index: _selectedCatIndex,
                    onSelect: (category, index, title) {
                      this._selectedCatIndex = index;
                      setState(() => this.title = title);
                      setState(() {
                        product = category == null ? oldData : category.dishes;
                      });
                    },
                  )),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    this.title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          ),

        actions: [InkWell(
            onTap: ()=>searchDialog(context , searchText: this.searchText, onSearchCompleted: (String txt) {
              this.searchText = txt ;
              if(txt.isEmpty && unSearched.isNotEmpty) setState(()=>this.product == this.unSearched);
              setState(() {
                this.unSearched = this.product ;
                this._getProducts(searchTxt: txt);
              });
            }),
            child: Icon(FontAwesomeIcons.search , color: PRIMARY_COLOR,))]
      ),
      body: AnimatedBuilder(
        animation: slideController,
        builder: (context, snap) {
          return Container(
            width: width,
            height: height,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 65),
            child: SmartRefresher(
              enablePullDown: true,
              onRefresh: _getProducts,
              controller: _refreshController,
              child: _loading
                  ? Loading()
                  :_selectedType == GRIDE
                  ? GridView.builder(
                padding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: this.product?.length ?? 0,
                itemBuilder: (context, index) {
                  Product dish = this.product[index];
                  GlobalKey key = GlobalKey();
                  return ProductWidget(product:  dish , category: _getCategoryforProduct(dish),);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 118 / gridViewHeight,
                  crossAxisCount: 2,
                  crossAxisSpacing: 11,
                  mainAxisSpacing: 11,
                ),
              ):
              ListView.builder(
                itemCount: this.product?.length ?? 0,
                itemBuilder: (context, index) {
                  Product dish = this.product[index];
                  GlobalKey key = GlobalKey();
                  return InkWell(
                    onTap: ()=>Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>ProductDetails(dish , _getCategoryforProduct(dish)))),
                    child: Container(
                      height: 91,
                      width: width - 32,
                      key: key,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.network(
                                dish?.image??"",
                                width: 50,
                                height: 50,
                                loadingBuilder: (context , image , loading){
                                  if(loading == null) return image ;
                                  return  Image.asset("assets/images/image_alt.png" ,width: 50, height: 50,);
                                },
                                fit: BoxFit.fill,
                              )),
                          SizedBox(
                            width: 16,
                          ),
                          Container(
                            width: width - 32 - 32 - 16 - 50 - 18,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width - 32 - 32 - 16 - 50 - 18-86,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${dish.name}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: TEXT_COLOR),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        convertNumbersString(
                                            "${dish?.price}") +
                                            " " +
                                            dish?.currency??"cr".tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: PRIMARY_COLOR),
                                      ),
                                      (dish?.original_qty??null) == null  ? Container() :Text(
                                        convertNumbersString(
                                            "${dish?.original_qty}") +
                                            " " +
                                            "قطعة",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: PRIMARY_COLOR),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if(_addAgain)
                                      if(this.counts.count == 0  )
                                        _showTypeDialog("${dish.id}",
                                            key: key, image: dish.image);
                                      else
                                        _addToCart("${dish.id}",
                                            key: key, image: dish.image);
                                  },
                                  child: Container(
                                    height: 86,
                                    width: 80,

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/shopping_cart.svg",
                                          width: 25,
                                          height: 25,
                                          color: TEXT_COLOR100,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          );
        },
      ),
      bottomSheet: SpedoButtonNav(
          text: "total".tr(),
          smtext: "${this.counts?.total_price ?? 0} ",
          cr: counts?.currency??"cr".tr(),
          loading: _countsloading,
          buttonSt: "finish_order".tr(),
          press: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ShoppingCart()),
            );
            _getCounts();
          }),
      floatingActionButton: Stack(
        children: [
          CartItem(
            this.fromPosition,
            onAnimationCompleted: () {
              this.fromPosition = null;
              this.flyingImage = null;
            },
            image: this.flyingImage,
          ),
          InkWell(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ShoppingCart()),
                );
                _getCounts();
              },
              child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: PRIMARY_COLOR),
                  child: CustomBadge(
                    badgeCount: this.counts?.count,
                    child: SvgPicture.asset(
                      "assets/icons/cart.svg",
                      width: 25,
                      height: 25,
                    ),
                  ))),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
