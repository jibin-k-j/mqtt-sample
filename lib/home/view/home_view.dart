import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:install_plugin_v2/install_plugin_v2.dart';
import 'package:lottie/lottie.dart';
import 'package:mqtt_test/config/app_colors.dart';
import 'package:mqtt_test/home/providers/all_devices_provider.dart';
import 'package:mqtt_test/home/providers/meter_provider.dart';
import 'package:mqtt_test/home/view/add_meter_view.dart';
import 'package:mqtt_test/home/view/profile_view.dart';
import 'package:mqtt_test/home/widgets/energy_meter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../config/app_version.dart';
import '../../util/custom_snackbar.dart';
import '../providers/light_provider.dart';
import '../view_model/home_view_model.dart';
import '../widgets/light_button.dart';
import 'add_light_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController pageController = PageController();
  final viewModel = HomeViewModel();
  bool isRequested = false;
  int _currentPageIndex = 0;

  @override
  void initState() {
    checkAppUpdate();
    super.initState();
  }

  void checkAppUpdate() async {
    final ref = FirebaseFirestore.instance.collection('app_version');
    try {
      await ref.get().then((value) {
        if (value.docs.isNotEmpty) {
          final versionFB = value.docs.first.get('version');
          if (versionFB != AppVersion.appVersion) {
            showUpdateDialog();
          }
        }
      });
    } catch (e) {
      log('Error from app update check $e');
    }
  }

  void _updateCurrentPageIndex(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final meterProvider = Provider.of<MeterProvider>(context);
    final meterProviderNonListener = Provider.of<MeterProvider>(context, listen: false);
    final lightProviderNonListener = Provider.of<LightProvider>(context, listen: false);
    final allDevicesProvider = Provider.of<AllDevicesProvider>(context);

    //CONNECTING TO MQTT IF DISABLED
    if (!viewModel.isMQTTActive()) {
      viewModel.initializeMQTT();
    }

    //SUBSCRIBING LIGHT
    if (allDevicesProvider.getLights.isNotEmpty) {
      final topic = 'onwords/${allDevicesProvider.getLights.first.productId}/currentStatus';
      final statusTopic = 'onwords/${allDevicesProvider.getLights.first.productId}/getCurrentStatus';

      if (!isRequested) {
        viewModel.sendLightMQTTRequest(statusTopic);
        isRequested = true;
      }
      viewModel.setupLightMQTT(topic, lightProviderNonListener);
    }
    //SUBSCRIBING METER
    if (allDevicesProvider.getMeters.isNotEmpty) {
      viewModel.setupMeterMQTT(meterProviderNonListener);
    }

    List<Widget> meterView = List.generate(allDevicesProvider.getMeters.length + 1, (index) {
      if (index == allDevicesProvider.getMeters.length) {
        return Center(
            child: addButton(
                title: 'Add Meter',
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddMeterView()));
                },
                height: 80.0,
                width: 200.0));
      } else {
        final meterIndex = meterProvider.getAllMeterReadings
            .indexWhere((element) => element.meterId == allDevicesProvider.getMeters[index].meterId);
        return EnergyMeter(
            size: size,
            meterModel: meterIndex > -1 ? meterProvider.getAllMeterReadings[meterIndex] : null,
            meterInfoModel: allDevicesProvider.getMeters[index]);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        leading: null,
        backgroundColor: AppColors.primaryColor,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('asset/icons/dashboard_icon.svg'),
            const SizedBox(width: 10.0),
            Text(
              'Dashboard',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileView()));
            },
            child: CircleAvatar(
              backgroundColor: AppColors.buttonColor,
              child: const Icon(Icons.person_rounded, color: Colors.black),
            ),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
      body: allDevicesProvider.isFetching
          ? Center(child: Lottie.asset('asset/animation/sync.json', width: size.width * .5))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Light',
                    style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 16.0),
                  ),
                ),
                //Buttons
                SizedBox(
                  height: size.height * .2,
                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: allDevicesProvider.getLights.length + 1,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                        childAspectRatio: 1 / .35,
                      ),
                      itemBuilder: (BuildContext ctx, int index) {
                        if (index == allDevicesProvider.getLights.length) {
                          return addButton(
                              title: 'Add Light',
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const AddLightView()),
                                );
                              });
                        }

                        return LightButton(
                          lightModel: allDevicesProvider.getLights[index],
                          mqttClientManager: viewModel.getMqttManager,
                        );
                      }),
                ),
                //Meter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Meter',
                    style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 16.0),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          allDevicesProvider.getMeters.length + 1,
                          (index) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CircleAvatar(
                              radius: 5.0,
                              backgroundColor:
                                  _currentPageIndex == index ? AppColors.buttonColor : AppColors.surfaceColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          physics: const BouncingScrollPhysics(),
                          allowImplicitScrolling: true,
                          scrollDirection: Axis.horizontal,
                          controller: pageController,
                          onPageChanged: _updateCurrentPageIndex,
                          children: meterView,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  //WIDGETS
  Widget addButton(
      {required String title, required VoidCallback onPressed, double width = 150.0, double height = 50.0}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.buttonColor.withOpacity(.2),
          border: Border.all(width: .5, color: Colors.grey.withOpacity(.5)),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_rounded, color: Colors.white),
            const SizedBox(width: 10.0),
            Text(
              title,
              style: GoogleFonts.poppins(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  showUpdateDialog() {
    return showDialog(
        context: context,
        builder: (ctx) {
          bool isUpdating = false;
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 10.0, sigmaX: 10.0),
            child: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: StatefulBuilder(builder: (ctx1, setState) {
                return AlertDialog(
                  backgroundColor: AppColors.surfaceColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  title: Text(
                    isUpdating ? 'Updating' : 'New Update available',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15.0, color: Colors.white),
                  ),
                  content: isUpdating
                      ? Lottie.asset('asset/animation/updating.json', height: 150.0)
                      : Text(
                          'You are currently using an outdated version of this application. An updated version is now available.',
                          style: GoogleFonts.poppins(fontSize: 15.0, color: Colors.white),
                        ),
                  actions: isUpdating
                      ? null
                      : [
                          CupertinoButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(fontSize: 15.0, color: Colors.grey),
                            ),
                          ),
                          CupertinoButton(
                            onPressed: () async {
                              final permission = await Permission.requestInstallPackages.isGranted;
                              if (permission) {
                                setState(() {
                                  isUpdating = true;
                                });
                                final result = await updateApp();
                                if (!result) {
                                  setState(() {
                                    isUpdating = false;
                                  });
                                }
                              } else {
                                await Permission.requestInstallPackages.request();
                              }
                            },
                            child: Text(
                              'Update now',
                              style: GoogleFonts.poppins(
                                fontSize: 15.0,
                                color: AppColors.buttonColor,
                              ),
                            ),
                          ),
                        ],
                );
              }),
            ),
          );
        });
  }

  Future<bool> updateApp() async {
    bool status = true;

    //update app
    final resultPath = FirebaseStorage.instance.ref('apk/app-release.apk');
    final appDocDir = await getExternalStorageDirectory();
    final String appDocPath = appDocDir!.path;
    final File tempFile = File('$appDocPath/energy_dashboard.apk');
    try {
      await resultPath.writeToFile(tempFile);
      await tempFile.create();
      await InstallPlugin.installApk(tempFile.path, 'com.onwords.energy_dashboard').then((result) {
        log('install apk $result');
      }).catchError((error) {
        log('install apk error: $error');
      });
    } on FirebaseException {
      if (!mounted) return false;
      CustomSnackBar.showErrorSnackBar(context, 'Unable to download app. Try again!');
      status = false;
    }

    return status;
  }

  @override
  void dispose() {
    viewModel.clearMQTT();
    pageController.dispose();
    super.dispose();
  }
}
