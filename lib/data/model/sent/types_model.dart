class TypeResponse {
  String message;
  int status;
  TypesModel type ;

  TypeResponse({ this.message, this.status ,this.type});

  factory TypeResponse.fromJson(Map<String, dynamic> json) {
    return TypeResponse(
      message: json['message'],
      status: json['status'],
      type: json['data'] == null ? null : TypesModel.fromJson(json['data'])
    );
  }
}

class TypesModel{
 bool isDelivery ;
 bool isPlace;
 bool isCollection ;

 TypesModel({ this.isDelivery, this.isCollection , this.isPlace});

  factory TypesModel.fromJson(Map json){
   if(json==null) return null ;
   return TypesModel(
     isCollection: int.parse("${json['enable_collection']??1}")==1,
     isPlace: int.parse("${json['enable_place']??1}")==1,
     isDelivery: int.parse("${json['enable_delivery']??1}")==1,
   );
 }
}