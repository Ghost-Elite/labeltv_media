class ApiLive {
  String? directUrl;
  String? androidUrl;
  String? webUrl;

  ApiLive({this.directUrl, this.androidUrl, this.webUrl});

  ApiLive.fromJson(Map<String, dynamic> json) {
    directUrl = json['direct_url'];
    androidUrl = json['android_url'];
    webUrl = json['web_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['direct_url'] = this.directUrl;
    data['android_url'] = this.androidUrl;
    data['web_url'] = this.webUrl;
    return data;
  }
}
