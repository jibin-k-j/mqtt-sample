import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_test/config/app_version.dart';
import 'package:mqtt_test/home/providers/meter_provider.dart';
import 'package:mqtt_test/home/providers/user_provider.dart';
import 'package:mqtt_test/user_landing.dart';
import 'package:mqtt_test/widgets/custom__elevated_button.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context, listen: false);
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
          'My Profile',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            //profile image
            CircleAvatar(
              backgroundColor: AppColors.buttonColor,
              radius: 70.0,
              child: const Icon(
                Icons.person_rounded,
                color: Colors.black,
                size: 100.0,
              ),
            ),
            const SizedBox(height: 50.0),
            //name
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: AppColors.surfaceColor.withOpacity(.3),
              ),
              child: Text(
                userData.name,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            //email
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: AppColors.surfaceColor.withOpacity(.3),
              ),
              child: Text(
                userData.email,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50.0),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(30.0),
                child: CustomElevatedButton(
                    onPressed: () async {
                      final meterProvider = Provider.of<MeterProvider>(context, listen: false);
                      final nav = Navigator.of(context);
                      setState(() {
                        isLoading = true;
                      });
                      await FirebaseAuth.instance.signOut();
                      meterProvider.clearMeterProvider();
                      userData.clearUserProvider();
                      nav.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const UserLanding()), (route) => false);
                    },
                    label: 'Sign Out',
                    radius: 10.0,
                    isLoading: isLoading)),
            //version
            Text(
              'Version ${AppVersion.appShowVersion}',
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13.0),
            ),
          ],
        ),
      ),
    );
  }
}
