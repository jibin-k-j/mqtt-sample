import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_test/user_landing.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../home/providers/user_provider.dart';
import '../../util/custom_snackbar.dart';
import '../../util/validation_mixin.dart';
import '../../widgets/custom__elevated_button.dart';
import '../firebase/firebase_operations.dart';
import '../model/user_model.dart';
import '../view_model/login_view_model.dart';
import '../view_model/response.dart';
import '../widgets/custom_text_form_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with ValidationMixin {
  final _signUpForm = GlobalKey<FormState>();
  String _email = '';
  String _name = '';
  String _password = '';
  String _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    final loginViewProvider = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Form(
          key: _signUpForm,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //TOP IMAGE
                SvgPicture.asset(
                  'asset/icons/sign_up.svg',
                  height: MediaQuery.of(context).size.height * .3,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //NAME FIELD
                    CustomTextFormField(
                        isObscure: false,
                        icon: const Icon(Icons.person_rounded, color: Colors.white),
                        validator: validateUsername,
                        hintText: 'Name',
                        textCapitalization: TextCapitalization.words,
                        inputAction: TextInputAction.next,
                        onSaved: (value) {
                          _name = value.toString().trim();
                        },
                        textFieldKey: 'name'),

                    const SizedBox(height: 20),
                    //EMAIL FIELD
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
                    const SizedBox(height: 20),
                    //PASSWORD FIELD
                    CustomTextFormField(
                        isObscure: !loginViewProvider.isVisible,
                        validator: validatePassword,
                        textCapitalization: TextCapitalization.none,
                        icon: const Icon(CupertinoIcons.padlock, color: Colors.white),
                        hintText: 'Password',
                        inputAction: TextInputAction.next,
                        onChanged: (value) {
                          setState(() {
                            _password = value.toString().trim();
                          });
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
                    const SizedBox(height: 20),
                    //CONFIRM PASSWORD FIELD
                    CustomTextFormField(
                        isObscure: !loginViewProvider.isVisible,
                        validator: (value) {
                          if (value.toString().trim() != _password) {
                            return 'Password mismatch!';
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.none,
                        icon: const Icon(CupertinoIcons.padlock_solid, color: Colors.white),
                        hintText: 'Confirm Password',
                        inputAction: TextInputAction.done,
                        onSaved: (value) {
                          _confirmPassword = value.toString().trim();
                        },
                        textFieldKey: 'confirmPassword'),
                    const SizedBox(height: 50),
                    //SIGNUP BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        onPressed: submitForm,
                        label: 'Sign Up',
                        radius: 15.0,
                        isLoading: loginViewProvider.isLoading,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Already have an account!!',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15.0),
                        ),
                        CupertinoButton(
                          child: Text('Login',
                              style: GoogleFonts.poppins(
                                  color: AppColors.buttonColor, fontSize: 16.0, fontWeight: FontWeight.w600)),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //METHODS
  Future<void> submitForm() async {
    final valid = _signUpForm.currentState!.validate();
    final loginProvider = Provider.of<LoginViewModel>(context, listen: false);
    if (valid) {
      FocusScope.of(context).unfocus();
      Object? response;
      loginProvider.toggleLoading(true);
      _signUpForm.currentState!.save();

      //PERFORMING FIREBASE OPERATION
      final result = await FirebaseOperations.createUser(email: _email, password: _confirmPassword, name: _name);
      log('result is $result');
      if (result.toString().contains('er:/')) {
        response = ErrorResponse(error: result.toString().substring(4));
      } else {
        final userInfo = UserModel(uid: result, email: _email, name: _name, photoURl: '');
        response = SuccessResponse(userData: userInfo);
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
        Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const UserLanding()), (route) => false);
      }
    }
  }
}
