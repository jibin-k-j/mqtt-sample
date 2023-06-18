import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_test/auth/widgets/custom_text_form_field.dart';
import 'package:mqtt_test/config/app_colors.dart';
import 'package:mqtt_test/home/firebase/firebase_home_operation.dart';
import 'package:mqtt_test/home/models/light_model.dart';
import 'package:mqtt_test/home/providers/user_provider.dart';
import 'package:mqtt_test/util/custom_snackbar.dart';
import 'package:mqtt_test/widgets/custom__elevated_button.dart';
import 'package:provider/provider.dart';

import '../providers/all_devices_provider.dart';

class AddLightView extends StatefulWidget {
  const AddLightView({Key? key}) : super(key: key);

  @override
  State<AddLightView> createState() => _AddLightViewState();
}

class _AddLightViewState extends State<AddLightView> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String id = '';
  String name = '';
  String pId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
          splashRadius: 20.0,
        ),
        title: Text(
          'Add Light',
          style: GoogleFonts.poppins(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: [
            //Bulb svg icon
            CircleAvatar(
              backgroundColor: AppColors.buttonColor,
              radius: 50.0,
              child: SvgPicture.asset(
                'asset/icons/light.svg',
                width: 40.0,
                colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 50.0),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '  Device ID',
                          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.w600),
                        ),
                        CustomTextFormField(
                            isObscure: false,
                            icon: null,
                            hintText: 'Enter ID',
                            textCapitalization: TextCapitalization.none,
                            inputAction: TextInputAction.next,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Id is empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              id = value.toString().trim();
                            },
                            textFieldKey: 'deviceId'),
                        const SizedBox(height: 20.0),
                        Text(
                          '  Device Name',
                          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.w600),
                        ),
                        CustomTextFormField(
                            isObscure: false,
                            icon: null,
                            hintText: 'Enter Name',
                            inputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Name is empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              name = value.toString().trim();
                            },
                            textFieldKey: 'deviceName'),
                        const SizedBox(height: 20.0),
                        Text(
                          '  Device Product ID',
                          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.w600),
                        ),
                        CustomTextFormField(
                            isObscure: false,
                            icon: null,
                            hintText: 'Enter Product ID',
                            inputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Product Id is empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              pId = value.toString().trim();
                            },
                            textFieldKey: 'devicePid'),
                        const SizedBox(height: 40.0),
                        SizedBox(
                            width: double.infinity,
                            child: CustomElevatedButton(
                                onPressed: submitForm, label: 'Add', radius: 15.0, isLoading: isLoading))
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitForm() async {
    final valid = _formKey.currentState!.validate();
    if (valid) {
      FocusScope.of(context).unfocus();
      setState(() {
        isLoading = true;
      });
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final deviceProvider = Provider.of<AllDevicesProvider>(context, listen: false);
      _formKey.currentState!.save();
      final light = LightModel(id: id, name: name, productId: pId);
      final status = await FirebaseHomeOperation.addLight(light, userProvider.uid);

      if (!mounted) return;
      if (status) {
        deviceProvider.addLight(light);
        Navigator.of(context).pop();
      } else {
        setState(() {
          isLoading = false;
        });
        CustomSnackBar.showErrorSnackBar(context, 'Unable to add device. Try again!');
      }
    }
  }
}
