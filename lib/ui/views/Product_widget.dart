import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tato/data/model/sent/category_model.dart';
import 'package:tato/data/model/sent/products_model.dart';
import 'package:tato/ui/views/product_details.dart';
import 'package:tato/utils/algorithms.dart';
import 'package:tato/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductWidget extends StatelessWidget {
  CategoryModel category ;
  Product product ;


  ProductWidget({this.category, this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductDetails(product , category))),
      child: Container(
          width: 187,
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
                height: 120,
                width: 154,
                child: Stack(
                  children: [
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child:Center(
                        child: Image.network(product?.image??"" , height:130 , loadingBuilder: (context , image , builder){
                          if(builder == null) return image ;
                          return Image.asset("assets/images/logo.png");

                        }, ),
                      ) ,
                    ),
                    (product?.original_qty??null) == null  ? Container(): PositionedDirectional(
                      bottom: 2,
                      start: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4 ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: PRIMARY_COLOR
                        ),
                        child: Center(child: Text("${product?.original_qty??0} قطعة "  , style: TextStyle(fontSize: 10 ,color: Colors.white),),),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product?.name??"" ,style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w500 , color: Colors.black), maxLines: 1 ,overflow: TextOverflow.ellipsis, ),
                  // Text(product?.desc??"" ,style: TextStyle(fontSize: 12  , color: Colors.black), maxLines: 2 ,overflow: TextOverflow.ellipsis, ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text( convertNumbersString("${product?.price}")+ " "+product?.currency??"cr".tr() , style: TextStyle(color: PRIMARY_COLOR , fontWeight: FontWeight.w500 , ),),
              ),
              //
              // SizedBox(height: 10,),
              //
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8),
              //   child: SpedoButton(
              //     height: 40,
              //     width: width-22-11 ,
              //     text: "add_to_cart".tr(),
              //     onPressed: ()=>_addToCart(product?.id??0),
              //     textColor: Colors.white,
              //     frontIcon: SvgPicture.asset("assets/icons/shopping_cart.svg"),
              //   ),
              // )

            ],
          )
      ),
    );
  }
}
