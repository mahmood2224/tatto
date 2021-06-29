import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tato/data/model/sent/products_model.dart';
import 'package:tato/ui/widgets/kintuky_text_field.dart';
import 'package:tato/ui/widgets/qty_dialog.dart';
import 'package:tato/ui/widgets/spedo_text_field.dart';
import 'package:tato/utils/algorithms.dart';
import 'package:tato/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class ItemCart extends StatefulWidget {
  Product dish ;

  Function onQtyChanged ;
  Function onNote ;
  Function onRemove ;
  ItemCart(this.dish , {this.onQtyChanged , this.onRemove ,this.onNote});

  @override
  _ItemCartState createState() {
    return _ItemCartState();
  }
}

class _ItemCartState extends State<ItemCart> {
  int qty = 1 ;
  @override
  void initState() {
    super.initState();
    this.qty = widget.dish?.qty ?? 1 ;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _plus(){
    setState(() => this.qty++);
    print("Qty Sent = $qty");
    widget.onQtyChanged(this.qty , widget.dish);
  }
  _minus(){
    if(qty > 1)
      setState(() => this.qty--);
      widget.onQtyChanged(this.qty , widget.dish);
  }

  TextEditingController _controller = new TextEditingController() ;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.only(right: 8 , top: 10, left: 18),
        width: width-40,
        height: 100,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.network("${widget.dish.image}" , width: 63, height: 63,fit: BoxFit.fill,)),
                    SizedBox(width: 12,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: width-32-63-150,
                            child: Text("${widget.dish?.name??""}" , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: TEXT_COLOR), maxLines: 1 , overflow: TextOverflow.ellipsis,)),
                        Text(convertNumbersString("${widget.dish?.price}")+" " + "${widget.dish.currency}", style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: PRIMARY_COLOR),),
                      ],
                    )

                  ],
                ),


                Container(
                  width: 60+16+20.0,
                  child: Column(
                    children: [
                      Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: InkWell(
                              onTap: ()=>widget.onRemove(widget.dish.id),
                              child: Icon(Icons.close , size: 25 , color: Colors.red,))),
                      Row(
                        children: [
                          InkWell(
                            onTap: _plus,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(color: PRIMARY_COLOR , width: 2),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Center(
                                child: Icon(FontAwesomeIcons.plus , size: 20,  color: PRIMARY_COLOR,),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text("$qty" ,style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color: TEXT_COLOR),),
                          SizedBox(width: 8),
                          InkWell(
                            onTap: _minus,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(color: PRIMARY_COLOR , width: 2),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Center(
                                child: Icon(FontAwesomeIcons.minus , size: 20,  color: PRIMARY_COLOR,),
                              ),
                            ),
                          ),
                        ],

                      ),
                    ],
                  ),
                )
              ],
            ),
            // SizedBox(height: 8,),
            // KintukyHouseTextField(
            //   width: width-50-16,
            //   height: 38,
            //   hint: "nots".tr(),
            //   border: 10,
            //   backgroundColor: Color(0xffEBEBEB),
            //   controller: _controller,
            //   onTextChange: (txt)=>widget.onNote(txt , widget?.dish?.id),
            // )
          ],

        )
    );
  }
}