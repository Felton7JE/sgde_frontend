class EmailRecuperacaoModel {
  final String email;

  EmailRecuperacaoModel({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}