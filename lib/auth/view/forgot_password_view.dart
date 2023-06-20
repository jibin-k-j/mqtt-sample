import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_test/config/app_colors.dart';

import '../../util/custom_snackbar.dart';
import '../../util/validation_mixin.dart';
import '../../widgets/custom__elevated_button.dart';
import '../firebase/firebase_operations.dart';
import '../widgets/custom_text_form_field.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
          splashRadius: 20.0,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Reset Password',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              //TOP IMAGE
              const Center(
                child: Image(
                  image: AssetImage('asset/icons/forgot_password.png'),
                  height: 350.0,
                ),
              ),
              const SizedBox(height: 50.0),
              //EMAIL FIELD
              Form(
                key: _formKey,
                child: CustomTextFormField(
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
              ),
              //SUBMIT BUTTON
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: submitForm,
                  label: 'Reset',
                  radius: 15.0,
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitForm() async {
    HapticFeedback.mediumImpact();
    final valid = _formKey.currentState!.validate();
    if (valid) {
      setState(() {
        isLoading = true;
      });
      FocusScope.of(context).unfocus();
      _formKey.currentState!.save();
      final result = await FirebaseOperations.resetPassword(email: _email);
      if (!mounted) return;
      if (result.toString() == 'true') {
        CustomSnackBar.showSuccessSnackBar(context, 'Forgot password mail sent');
        Navigator.of(context).pop();
      } else {
        setState(() {
          isLoading = false;
        });
        CustomSnackBar.showErrorSnackBar(context, result);
      }
    }
  }
}
