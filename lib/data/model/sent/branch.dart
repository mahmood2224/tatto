class BranchResponse {
    List<Branch> branches;
    String message;
    int status;

    BranchResponse({this.branches, this.message, this.status});

    factory BranchResponse.fromJson(Map<String, dynamic> json) {
        return BranchResponse(
            branches: json['data'] != null ? (json['data'] as List).map((i) => Branch.fromJson(i)).toList() : null,
            message: json['message'], 
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['status'] = this.status;
        if (this.branches != null) {
            data['data'] = this.branches.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Branch {
    bool open;
    String created_at;
    String from;
    int id;
    String name;
    String printer_code;
    int status;
    String to;
    String updated_at;

    Branch({this.open, this.created_at, this.from, this.id, this.name, this.printer_code, this.status, this.to, this.updated_at});

    factory Branch.fromJson(Map<String, dynamic> json) {
        return Branch(
            open: int.parse("${json['open']??0}") == 1 ,
            created_at: json['created_at'], 
            from: json['from'], 
            id: json['id'], 
            name: json['name'], 
            printer_code: json['printer_code'], 
            status: json['status'], 
            to: json['to'], 
            updated_at: json['updated_at'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['open'] = this.open;
        data['created_at'] = this.created_at;
        data['from'] = this.from;
        data['id'] = this.id;
        data['name'] = this.name;
        data['printer_code'] = this.printer_code;
        data['status'] = this.status;
        data['to'] = this.to;
        data['updated_at'] = this.updated_at;
        return data;
    }
}