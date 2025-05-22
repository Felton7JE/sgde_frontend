class AcessTokenModel {
  final String? token; 
  AcessTokenModel({this.token});

  factory AcessTokenModel.fromJson(Map<String, dynamic> json) {
   
    return AcessTokenModel(
      token: json['token'] as String?,
    );
  }
}