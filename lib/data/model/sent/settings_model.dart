class ColorModel {
    String data;
    String message;
    int status;

    ColorModel({this.data, this.message, this.status});

    factory ColorModel.fromJson(Map<String, dynamic> json) {
        return ColorModel(
            data: json['data'],
            message: json['message'],
            status: json['status'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['data'] = this.data;
        data['message'] = this.message;
        data['status'] = this.status;
        return data;
    }
}

class DiscountModel {
    int discount;
    String message;
    int status;

    DiscountModel({this.discount, this.message, this.status});

    factory DiscountModel.fromJson(Map<String, dynamic> json) {
        return DiscountModel(
            discount: int.parse("${json['data']??0}"),
            message: json['message'],
            status: json['status'],
        );
    }

}