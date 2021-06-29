import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tato/data/model/sent/category_model.dart';
import 'package:tato/data/model/sent/products_model.dart';
import 'package:tato/utils/colors.dart';

class FiltterComponant extends StatefulWidget {
 List<CategoryModel> categories ;
  Function onSelect ;
  int index ;
 FiltterComponant(this.categories , {this.onSelect ,this.index });

  @override
  _FiltterComponantState createState() {
    return _FiltterComponantState();
  }
}

class _FiltterComponantState extends State<FiltterComponant> {
ScrollController _controller = new ScrollController();
  @override
  void initState() {
    super.initState();
    this._selectedIndex = widget.index??0 ;
  }

  @override
  void dispose() {
    super.dispose();
  }
  int _selectedIndex =0 ;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      height: height/1.5,
      padding: EdgeInsets.symmetric(horizontal: 27 ,vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("choose_category".tr(), style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold , color: PRIMARY_COLOR),),
          Text("pleace_choose_category".tr(), style: TextStyle(fontSize: 12 , fontWeight: FontWeight.w500 , color: TEXT_COLOR100),textAlign: TextAlign.center,),
          SizedBox(height: 15,),
          Container(
            height: (height/1.5)-15-22 -50-28,
            child: Scrollbar(
              controller: _controller,
              isAlwaysShown: true,
              child: ListView.separated(
                controller: _controller,
                separatorBuilder: (context , index){
                  return Container(
                    height: 1,
                    color: Colors.black12
                  );
                },
                  itemCount: (widget.categories?.length??0)+1,
                  itemBuilder: (context , index){
                    CategoryModel cat ;
                    if(index != 0)
                      cat = widget.categories[index-1] ;
                    return InkWell(
                      onTap: (){
                        setState(()=>_selectedIndex=index);
                        widget.onSelect(cat , index , cat?.name??"اختر الفئه");
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 40,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.grey,
                            ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${index==0 ? "اختر الفئه":cat.name}", style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold , color: PRIMARY_COLOR),),
                              Radio(value: index, groupValue: _selectedIndex, onChanged: (checked){
                                setState(()=>_selectedIndex=index);
                                widget.onSelect(cat , index , cat?.name??"اختر الفئه");
                                Navigator.of(context).pop();
                              },activeColor: PRIMARY_COLOR,)

                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),
          ),
        ],
      ),

    );
  }
}