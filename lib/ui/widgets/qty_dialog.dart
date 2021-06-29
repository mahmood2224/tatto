import 'package:flutter/material.dart';
import 'package:tato/ui/widgets/spedo_button.dart';
import 'package:tato/ui/widgets/spedo_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tato/utils/Dialog.dart';

class QtyDialog extends StatelessWidget {
  TextEditingController _controller = new TextEditingController() ;
  Function onDone ;

  QtyDialog(this.onDone);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("enter_qty".tr() , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold , ),),
          SizedBox(height: 16,),
          SpedoTextField(
            controller: _controller,
            hint: "please_enter_qty".tr(),
            textType: TextInputType.number,
            width: width-32-32 ,
            height: 45,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16,),
          SpedoButton(
            height: 45,
            width: width/2,
            textColor: Colors.white,
            onPressed:(){
              Navigator.of(context).pop();
              if(this.onDone != null )this.onDone(_controller.text);
              },
            text: "done".tr(),
          )
        ],
      ),
    );
  }
}


showQtyDialog(BuildContext context,{@required Function onDone }){
  double height = MediaQuery.of(context).size.height;
  ShowDialog(context: context , alignment: Alignment.center , height: 200 , radius: BorderRadius.circular(15) , child: QtyDialog(onDone));
}