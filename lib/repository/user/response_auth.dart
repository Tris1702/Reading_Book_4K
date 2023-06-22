// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class ResponseAuth {
  UserCredential? userCredential;
  String? errorMessage;
  ResponseAuth({
    this.userCredential,
    this.errorMessage,
  });

  ResponseAuth copyWith({
    UserCredential? userCredential,
    String? errorMessage,
  }) {
    return ResponseAuth(
      userCredential: userCredential ?? this.userCredential,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ResponseAuth.fromMap(Map<String, dynamic> map) {
    return ResponseAuth(
      userCredential: map['userCredential'] != null ? map['userCredential'] as UserCredential : null,
      errorMessage: map['errorMessage'] != null ? map['errorMessage'] as String : null,
    );
  }

  factory ResponseAuth.fromJson(String source) => ResponseAuth.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ResponseAuth(userCredential: $userCredential, errorMessage: $errorMessage)';

  @override
  bool operator ==(covariant ResponseAuth other) {
    if (identical(this, other)) return true;
  
    return 
      other.userCredential == userCredential &&
      other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => userCredential.hashCode ^ errorMessage.hashCode;
}
