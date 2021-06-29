import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tato/data/api_provider.dart';
import 'package:tato/data/model/sent/category_model.dart';
import 'package:tato/data/model/sent/counts_model.dart';
import 'package:tato/data/model/sent/products_model.dart';
import 'package:tato/data/model/sent/types_model.dart';
import 'package:tato/ui/views/shopping_cart.dart';
import 'package:tato/ui/widgets/Loading.dart';
import 'package:tato/ui/widgets/app_bar.dart';
import 'package:tato/ui/widgets/button_nav.dart';
import 'package:tato/ui/widgets/qty_dialog.dart';
import 'package:tato/ui/widgets/spedo_button.dart';
import 'package:tato/ui/widgets/type_dialog.dart';
import 'package:tato/utils/Dialog.dart';
import 'package:tato/utils/algorithms.dart';
import 'package:tato/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductDetails extends StatefulWidget {
  Product product ;
  CategoryModel cat ;

  ProductDetails(this.product , this.cat);

  @override
  _ProductDetailsState createState() {
    return _ProductDetailsState();
  }
}

class _ProductDetailsState extends State<ProductDetails> {

  int productQty = 1 ;
  bool _loading = false ;
  bool _buttonLoading = false ;
  Count _counts ;
 TypesModel types ;


  @override
  void initState() {
    super.initState();
    _getCounts();
    _getTypes();
  }

  _plus(){
    setState(()=> this.productQty ++ );
  }

  _mince(){
    setState(() {
      this.productQty = this.productQty == 1 ? 1 : this.productQty - 1 ;
    });
  }

  _getCounts() {
    setState(() => _loading = true);
    ApiProvider.getCounts(
        onError: () => setState(() => _loading = false),
        onSuccess: (count) {
          this._counts = count ;
          setState(() =>this._loading =false );
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

  _addToCartApi() {
    setState(() => _buttonLoading = true);

    ApiProvider.addToCart(
        productId: "${widget?.product?.id??0}",
        qty: this.productQty,
        onSuccess: (message , count ) {
          showToast(message, backgroundColor: Colors.green);
         setState(() => this._buttonLoading = false );
         _getCounts();
        },
        onError: (message) {
          showToast(message, backgroundColor: Colors.red);
          setState(() => this._buttonLoading = false );
        });
  }

  _addToCart(){
    if((this._counts?.count??0) == 0)
      ShowDialog(
          context: context,
          height: MediaQuery.of(context).size.height / 2.5,
          alignment: Alignment.center,
          radius: BorderRadius.circular(16),
          child: TypeDialog(this.types,onSuccess: ()=>_addToCartApi(),));
    else
      _addToCartApi();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double fontSize = 31 ;
    String qty = "$productQty";
    fontSize = 32.0 - qty.length*4 ;
    return Scaffold(
      appBar: SpedoAppBar(context,
          getCounts: _getCounts,
          counts: this._counts , title: "${widget?.product?.name??""}"),
      body: Container(
        width: width,
        height: height,
        child: _loading ? Loading() :SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8 ,),
              Container(
                width: width,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      height:226 ,
                      width: width,
                      child:  CarouselSlider(
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        items: (widget.product?.images??[]).map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Image.network(
                                    i??"",
                                    fit: BoxFit.contain,
                                  ));
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 8,),
                    Container(
                        width: width/2,
                        child: Text(widget?.product?.name??"" , style: TextStyle(fontSize: 17 , fontWeight: FontWeight.w500 ), textAlign: TextAlign.center,)),
                    SizedBox(height: 8,),
                    Text( convertNumbersString("${widget.product?.price??0}") + " "+widget.product?.currency??"cr".tr() , style: TextStyle(color: PRIMARY_COLOR , fontWeight: FontWeight.w500 , fontSize: 21 ),),
                    SizedBox(height: 4,),
                    (widget?.product?.original_qty??null) == null ? Container():Text("${widget.product?.original_qty}" +" قطعة " ,style: TextStyle(fontSize: 12  , color: Colors.black), maxLines: 2 ,overflow: TextOverflow.ellipsis, ),
                    SizedBox(height: 4,),


                  ],
                ),
              ),
              SizedBox(height: 8 ,),
              Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                color: Colors.white,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: width/2 - 32 - 16,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap :_plus ,
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: PRIMARY_COLOR_70 ,
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Center(
                                    child: Icon(FontAwesomeIcons.plus , color: PRIMARY_COLOR, size: 25,),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: ()=>showQtyDialog(context, onDone: (String qty)=>setState(()=>this.productQty = int.parse(qty))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text("${this.productQty}" , style: TextStyle(fontSize: fontSize ,color: PRIMARY_COLOR , fontWeight: FontWeight.bold),),
                                ),
                              ),
                              InkWell(
                                onTap: _mince,
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                      color: PRIMARY_COLOR_30 ,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Center(
                                    child: Icon(FontAwesomeIcons.minus , color: PRIMARY_COLOR_70, size: 25,),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SpedoButton(
                          height: 40,
                          width: width/2 - 32 - 5,
                          text: "add_to_cart".tr(),
                          fontSize: 12,
                          textColor: Colors.white,
                          loading: _buttonLoading,
                          onPressed: _addToCart,
                          frontIcon: SvgPicture.asset("assets/icons/shopping_cart.svg" , width: 15,),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 8 ,),
              Container(
                width: width,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(height: 20, width: 5, color: PRIMARY_COLOR,),
                        SizedBox(width: 4,),
                        Text("product_details".tr() , style: TextStyle(color: PRIMARY_COLOR , fontWeight: FontWeight.w500 , fontSize: 14 ),)
                      ],
                    ),
                    SizedBox(height: 16,),
                    Text(widget.product?.desc??"" ,  style: TextStyle(fontSize: 14 ),)
                  ],
                ),
              ),
              SizedBox(height: 8 ,),
              widget.cat == null ? Container():Container(
                width: width,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(height: 20, width: 5, color: PRIMARY_COLOR,),
                        SizedBox(width: 4,),
                        Text("other_products".tr() , style: TextStyle(color: PRIMARY_COLOR , fontWeight: FontWeight.w500 , fontSize: 14 ),)
                      ],
                    ),
                    SizedBox(height: 16,),
                   Container(
                     width: width,
                     height: 194,
                     child: ListView.builder(
                       scrollDirection: Axis.horizontal,
                       itemCount: widget.cat?.dishes?.length??0,
                         itemBuilder: (context, index) {
                           Product product = widget.cat?.dishes[index] ;
                           return InkWell(
                             onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductDetails(product , widget.cat ))),
                             child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                 height: 194,
                                 width: 154,
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(16),
                                     color: Colors.white
                                 ),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     //image Container
                                     Container(
                                       height: 130,
                                       decoration: BoxDecoration(
                                           borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                           image: DecorationImage(image: NetworkImage(product?.image??""))
                                       ),
                                     ),
                                     SizedBox(height: 10,),
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text(product?.name??"" ,style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w500 , color: Colors.black), maxLines: 1 ,overflow: TextOverflow.ellipsis, ),
                                       ],
                                     ),

                                     Text( convertNumbersString("${product?.price}")+ " "+product?.currency??"cr".tr() , style: TextStyle(color: PRIMARY_COLOR , fontWeight: FontWeight.w500 , ),),

                                   ],
                                 )
                             ),
                           );
                         }
                     ),
                   )
                  ],
                ),
              ),
              SizedBox(height: 80 ,),
            ],
          ),
        ),
      ),

        bottomSheet: SpedoButtonNav(
            text: "total".tr(),
            smtext: "${this._counts?.total_price ?? 0} ",
            cr:_counts?.currency??"cr".tr(),
            right:20 ,
            loading: _loading,
            buttonSt: "finish_order".tr(),
            press: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ShoppingCart()),
              );
              _getCounts();
            })
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}