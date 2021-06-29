class AboutUsResponse {
    AboutUsModel data;
    String message;
    int status;

    AboutUsResponse({this.data, this.message, this.status});

    factory AboutUsResponse.fromJson(Map<String, dynamic> json) {
        return AboutUsResponse(
            data: json['data'] != null ? AboutUsModel.fromJson(json['data']) : null,
            message: json['message'], 
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['status'] = this.status;
        if (this.data != null) {
            data['data'] = this.data.toJson();
        }
        return data;
    }
}

class AboutUsModel {
    String about_us;
    String created_at;
    int id;
    String phone_number;
    String share_string;
    String updated_at;

    AboutUsModel({this.about_us, this.created_at, this.id, this.phone_number, this.share_string, this.updated_at});

    factory AboutUsModel.fromJson(Map<String, dynamic> json) {
        return AboutUsModel(
            about_us: json['about_us'], 
            created_at: json['created_at'], 
            id: json['id'], 
            phone_number: json['phone_number'], 
            share_string: json['share_string'], 
            updated_at: json['updated_at'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['about_us'] = this.about_us;
        data['created_at'] = this.created_at;
        data['id'] = this.id;
        data['phone_number'] = this.phone_number;
        data['share_string'] = this.share_string;
        data['updated_at'] = this.updated_at;
        return data;
    }
}