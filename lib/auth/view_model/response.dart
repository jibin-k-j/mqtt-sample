import 'package:firebase_auth/firebase_auth.dart';
import 'package:mqtt_test/auth/model/user_model.dart';

//SUCCESS
class SuccessResponse {
  final UserModel userData;
  SuccessResponse({required this.userData});
}


//ERROR
class ErrorResponse {
  final String error;
  ErrorResponse({required this.error});
}
