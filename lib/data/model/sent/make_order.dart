import 'package:shared_preferences/shared_preferences.dart';

class MakeOrderModel{
  String userPhone;
  int zoneId ;
  int branchId ;
  String totalPrice ;
  String address ;
  String name ;
  String lat ;
  String lng ;
  int orderType ;
  String discount ;
  double shippingPrice ;


  MakeOrderModel({this.userPhone,this.shippingPrice, this.orderType ,this.branchId,this.zoneId, this.totalPrice, this.address,
      this.name, this.lat, this.lng , this.discount});

  Map<String,dynamic> toJson() {
    Map<String, dynamic> data = new Map();
    if (userPhone != null) data['phone'] = this.userPhone;
    if (zoneId != null) data['zone_id'] = this.zoneId;
    if (totalPrice != null) data['total_price'] = this.totalPrice;
    if (name != null) data['name'] = this.name;
    if (address != null) data['address'] = this.address;
    if (branchId != null) data['branch_id'] = this.branchId;
    if (lat != null) data['lat'] = this.lat;
    if (lng != null) data['lng'] = this.lng;
    if (orderType != null) data['order_type'] = this.orderType;
    if (discount != null) data['discount'] = this.discount;

    return data;
  }

 factory MakeOrderModel.fromLocal(SharedPreferences prefs){
    if(prefs == null) return new MakeOrderModel() ;
    MakeOrderModel order =  MakeOrderModel(
      name: prefs.getString("name"),
      userPhone: prefs.getString("phone"),
      address: prefs.getString("address"),
      zoneId: prefs.getInt("zone_id"),
      branchId: prefs.getInt("branch_id"),
      orderType: prefs.getInt("type"),
      shippingPrice: prefs.getDouble("shipping_price")
    );

    print("make order model is : ${order?.orderType}");
    return order ;
  }
}

saveToLocal(MakeOrderModel makeOrder) async{
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  print("saving type is : ${makeOrder.orderType}");
  if(makeOrder.name != null )_prefs.setString("name", makeOrder.name);
  if(makeOrder.userPhone != null )_prefs.setString("phone", makeOrder.userPhone);
  if(makeOrder.address != null )_prefs.setString("address", makeOrder.address);
  if(makeOrder.zoneId != null )_prefs.setInt("zone_id", makeOrder.zoneId);
  if(makeOrder.branchId != null )_prefs.setInt("branch_id", makeOrder.branchId);
   _prefs.setInt("type", makeOrder.orderType);
  if(makeOrder.shippingPrice != null )_prefs.setDouble("shipping_price", makeOrder.shippingPrice);
}

clearUnReusable () async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.remove("zone_id");
  _prefs.remove("branch_id");
  _prefs.remove("type");
}

getFromLocal()async{
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  bool canAccess = _prefs.containsKey("type") ;
  MakeOrderModel order = MakeOrderModel.fromLocal(canAccess ?_prefs : null );
  return order ;
}


class SaveOrderResponseResponse {
  String message;
  int status;
  String data ;
  SaveOrderResponseResponse({ this.message,this.data,this.status });

  factory SaveOrderResponseResponse.fromJson(Map<String, dynamic> json) {
    return SaveOrderResponseResponse(
        message: json['message'],
        status: json['status'],
        data: "${json['data']}"
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
