import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:tato/data/api_provider.dart';
import 'package:tato/data/model/sent/branch.dart';
import 'package:tato/data/model/sent/make_order.dart';
import 'package:tato/data/model/sent/orders_model.dart';
import 'package:tato/data/model/sent/types_model.dart';
import 'package:tato/data/model/sent/zone_model.dart';
import 'package:tato/ui/widgets/spedo_button.dart';
import 'package:tato/ui/widgets/spedo_drop_down.dart';

import 'package:tato/utils/colors.dart';

class TypeDialog extends StatefulWidget {

  Function onSuccess ;
  TypesModel types ;

  TypeDialog(this.types,{this.onSuccess});

  @override
  _TypeDialogState createState() {
    return _TypeDialogState();
  }
}

class _TypeDialogState extends State<TypeDialog> {

  int _selectedType  ;
  List<Zone> zones =[] ;
  List<Branch> branches =[] ;

  Zone zone  ;
  Branch branch ;
  @override
  void initState() {
    super.initState();
    _getZones() ;
    _getBranches();
    _initValue();

  }

  _initValue(){

    if((widget.types?.isDelivery??true)){
      this._selectedType = DELIVERY ;
      print("selected Index = delivery");
      _checkCount();
      return ;
    }

    if((widget.types?.isCollection??true)){
      this._selectedType = COLLECTION ;
      print("selected Index = collection");
      _checkCount();
      return ;
    }

    if((widget.types?.isPlace??true)){
      this._selectedType = PLACE ;
      print("selected Index = place");
      _checkCount();
      return ;
    }
  }

  _setSelected(int type){
    setState(() => _selectedType = type  );
    _checkCount();
  }

  _checkCount(){
    if(_selectedType == DELIVERY)
      if((this.zones?.length ?? 0) == 1 ) {
        this.zone = this.zones[0];
        return;
      }

    if(_selectedType == COLLECTION )
      if((this.branches?.length??0) == 1 ){
        this.branch = this.branches[0] ;
        return ;
      }
  }

  _getZones(){
    ApiProvider.getAllZones(onError: (){} , onSuccess: (zones){
      setState(() {
        this.zones = zones ;
      });
    });
  }
  _getBranches(){
    ApiProvider.getAllBranches(onError: (){} , onSuccess: (branches){
      setState(() {
        this.branches = branches ;
      });
    });
  }


 _onSuccess(){
    if(this._selectedType == DELIVERY) {
      if (zone == null) {
        showToast(
            "من فضلك اختر المنطقة", backgroundColor: Colors.red);
        return;
      }
      else if (!this.zone.open){
        showToast(
            "هذه المنطقة غير متاحة حاليا", backgroundColor: Colors.red);
        return;
      }

    }

    if(this._selectedType == COLLECTION) {
      if (branch == null) {
        showToast(
            "من فضلك اختر الفرع", backgroundColor: Colors.red);
        return;
      }
      else if (!this.branch.open) {
        showToast(
            "هذه الفرع غير متاحة حاليا", backgroundColor: Colors.red);
        return;
      }
    }

    MakeOrderModel data = new MakeOrderModel(orderType: _selectedType , zoneId: zone?.id , branchId: branch?.id ,shippingPrice: double.parse("${ zone?.shipping_price??0.0}"));
    saveToLocal(data);
    widget.onSuccess() ;
    Navigator.of(context).pop();
 }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("اختر نوع الطلب" , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold ,color: TEXT_COLOR100),),
          SizedBox(height: 18,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                (widget.types?.isDelivery??true) ? Expanded(
                    flex:1,
                    child: InkWell(
                      onTap: ()=>_setSelected(DELIVERY),
                      child: Container(
                      height: 42,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _selectedType == DELIVERY ? PRIMARY_COLOR :TEXT_COLOR100 , width: 1 ),
                        color: _selectedType == DELIVERY ? PRIMARY_COLOR : Colors.white
                      ),
                        child: Center(
                          child: Text("توصيل" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold , color:_selectedType == DELIVERY  ? Colors.white: TEXT_COLOR100),),
                        ),
                ),
                    ),
                  ):Container(),
                (widget.types?.isCollection??true) ?Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: ()=>_setSelected(COLLECTION),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _selectedType == COLLECTION ? PRIMARY_COLOR :TEXT_COLOR100 , width: 1 ),
                        color: _selectedType == COLLECTION ? PRIMARY_COLOR : Colors.white
                      ),
                        child: Center(
                          child: Text("استلام مكتب" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold , color:_selectedType == COLLECTION  ? Colors.white: TEXT_COLOR100),),
                        ),
                ),
                    ),
                  ) :Container(),
                (widget.types?.isPlace??true) ?Expanded(
                    flex:1,
                    child: InkWell(
                      onTap: ()=>_setSelected(PLACE),
                      child: Container(
                      height: 42,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _selectedType == PLACE ? PRIMARY_COLOR :TEXT_COLOR100 , width: 1 ),
                        color: _selectedType == PLACE ? PRIMARY_COLOR : Colors.white
                      ),
                        child: Center(
                          child: Text("صالة" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold , color:_selectedType == PLACE  ? Colors.white: TEXT_COLOR100),),
                        ),
                ),
                    ),
                  ) : Container(),
              ],
            ),
          ),
          SizedBox(height: 16,),
         ( _selectedType == DELIVERY  && (this.zones?.length??0)>1)? SpedoDropdown(
            width: width-22-40,
            height: 42,
            textAlign: Alignment.center,
            backgroundColor: INPUT_BACKGROUND,
            items: [DropDownModel(name:"اختر المنطقة" , object: null , isSelected: true  )  , ...zones.map((e) => DropDownModel(name: e.zone_name , object: e))],
            onSelectItem: (Zone zone){
              this.zone = zone ;
              this.branch = null ;
            },
          ) :Container() ,

         ( _selectedType == COLLECTION && (this.branches?.length??0)>1) ?  new SpedoDropdown(
            width: width-22-40,
            height: 42,
            textAlign: Alignment.center,
            backgroundColor: INPUT_BACKGROUND,
            items: [DropDownModel(name:"اختر الفرع" , object: null , isSelected: true  )  , ...branches.map((e) => DropDownModel(name: e.name , object: e))],
            onSelectItem: (Branch branch){
              this.branch = branch ;
              this.zone = null ;

            },
          ) : Container() ,
          SizedBox(height: 16,),
          SpedoButton(
            height: 40,
            width: width/2.5,
            text: "اكمال الطلب",
            textColor: Colors.white,
            onPressed: _onSuccess,
            loading:false,
            icon: Container(
              width: 25,
              height: 25,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
              ),
              child: Center(
                child: Icon(Icons.arrow_forward_ios , size: 15, color: PRIMARY_COLOR,),
              ),
            ),
          ),
          SizedBox(height: 8,),
          InkWell(
              onTap: ()=>Navigator.pop(context),
              child: Text("الغاء" , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold ,color: TEXT_COLOR100),)),

        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}