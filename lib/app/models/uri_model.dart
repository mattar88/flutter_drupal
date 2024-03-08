class Uri {
  String? value;
  String? url;

  Uri({this.value, this.url});

  Uri.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['url'] = this.url;
    return data;
  }
}
