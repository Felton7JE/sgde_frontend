// lib/models/auth/two_factor_auth_model.dart
class TwoFactorAuthModel {
  final String codigo2FA;

  TwoFactorAuthModel({required this.codigo2FA});

  Map<String, dynamic> toJson() {
    return {
      'codigo2FA': codigo2FA,
    };
  }
}