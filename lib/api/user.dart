class User {
  String id;
  String name;
  String email;
  String password;
  String token;

  User({this.id, this.name, this.email, this.password, this.token});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    email = json['email'];
    password = json['password'];
    token = json['api_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['api_token'] = this.token;
    return data;
  }
}
