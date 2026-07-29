class AuthenticateResponse{

  final String token;

  const AuthenticateResponse({required this.token});

  factory AuthenticateResponse.fromJson(Map<String, dynamic> json){
    return AuthenticateResponse(
        token: json["token"] as String
    );
  }

}