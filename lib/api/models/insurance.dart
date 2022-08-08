class InsuranceModel {
  List<CompanyData> data;
  int status;
  String massage;

  InsuranceModel({this.data, this.status, this.massage});

  InsuranceModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      // ignore: deprecated_member_use
      data = new List<CompanyData>();
      json['data'].forEach((v) {
        data.add(new CompanyData.fromJson(v));
      });
    }
    status = json['status'];
    massage = json['massage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['massage'] = this.massage;
    return data;
  }
}

class CompanyData {
  int id;
  //String name;
  Trans trans;

  CompanyData({this.id, this.trans});

  CompanyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trans = Trans.fromJson(json["trans"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class Trans {
  Trans({
    this.title,
  });

  String title;
  Trans.fromJson(Map<String, dynamic> json) {
    title = json['name'];
  }
  // factory Trans.fromJson(Map<String, dynamic> json) => Trans(
  //     title: json["title"],
  // );

  Map<String, dynamic> toJson() => {
        "name": title,
      };
}
