class PostpondModels {
  List<BranchesData> data;
  int status;
  String massage;

  PostpondModels({this.data, this.status, this.massage});

  PostpondModels.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      // ignore: deprecated_member_use
      data = new List<BranchesData>();
      json['data'].forEach((v) {
        data.add(new BranchesData.fromJson(v));
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

class BranchesData {
  int id;
  var max;
  Trans trans;

  BranchesData({this.id, this.trans});

  BranchesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    max = json['maximum_delivery_time'];
    trans = Trans.fromJson(json["trans"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['maximum_delivery_time'] = this.max;
    return data;
  }
}

class Trans {
  Trans({
    this.title,
  });

  String title;
  Trans.fromJson(Map<String, dynamic> json) {
    title = json['title'];
  }
  // factory Trans.fromJson(Map<String, dynamic> json) => Trans(
  //     title: json["title"],
  // );

  Map<String, dynamic> toJson() => {
        "title": title,
      };
}
