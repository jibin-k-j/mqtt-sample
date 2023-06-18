import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_test/auth/model/user_model.dart';
import 'package:mqtt_test/auth/view_model/login_view_model.dart';
import 'package:mqtt_test/auth/view_model/response.dart';
import 'package:mqtt_test/auth/widgets/custom_text_form_field.dart';
import 'package:mqtt_test/home/providers/user_provider.dart';
import 'package:mqtt_test/util/custom_snackbar.dart';
import 'package:mqtt_test/widgets/custom__elevated_button.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../util/validation_mixin.dart';
import '../firebase/firebase_operations.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with ValidationMixin {
  final _loginKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final loginViewProvider = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _loginKey,
            child: Column(
              children: [
                //email
                CustomTextFormField(
                    isObscure: false,
                    icon: const Icon(Icons.email_rounded, color: Colors.white),
                    validator: validateEmail,
                    hintText: 'Email',
                    textCapitalization: TextCapitalization.none,
                    inputType: TextInputType.emailAddress,
                    inputAction: TextInputAction.next,
                    onSaved: (value) {
                      _email = value.toString().trim();
                    },
                    textFieldKey: 'email'),
                const SizedBox(height: 20.0),
                //password
                CustomTextFormField(
                    isObscure: !loginViewProvider.isVisible,
                    validator: validatePassword,
                    textCapitalization: TextCapitalization.none,
                    icon: const Icon(Icons.email_rounded, color: Colors.white),
                    hintText: 'Password',
                    inputAction: TextInputAction.done,
                    onSaved: (value) {
                      _password = value.toString().trim();
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        !loginViewProvider.isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        final provider = Provider.of<LoginViewModel>(context, listen: false);
                        provider.toggleVisibility(!loginViewProvider.isVisible);
                      },
                      splashRadius: 20.0,
                    ),
                    textFieldKey: 'password'),

                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    onPressed: submitForm,
                    label: 'Login',
                    radius: 15.0,
                    isLoading: loginViewProvider.isLoading,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //METHODS
  Future<void> submitForm() async {
    final valid = _loginKey.currentState!.validate();
    final loginProvider = Provider.of<LoginViewModel>(context, listen: false);
    if (valid) {
      FocusScope.of(context).unfocus();
      Object? response;
      loginProvider.toggleLoading(true);
      _loginKey.currentState!.save();

      //PERFORMING FIREBASE OPERATION
      final result = await FirebaseOperations.loginUser(email: _email, password: _password);
      if (result.toString().contains('er:/')) {
        response = ErrorResponse(error: result.toString().substring(4));
      } else {
        response = SuccessResponse(userData: result as UserModel);
      }
      loginProvider.toggleLoading(false);
      log('result is $result and response is $response');

      //PERFORMING FURTHER ACTIONS BASED ON RESULT
      if (!mounted) return;
      if (response is ErrorResponse) {
        CustomSnackBar.showErrorSnackBar(context, response.error);
      } else if (response is SuccessResponse) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.uid = response.userData.uid;
        userProvider.email = response.userData.email;
        userProvider.name = response.userData.name;
        userProvider.url = response.userData.photoURl;
        log('Data is ${response.userData.name}');
      }
    }
  }
}
