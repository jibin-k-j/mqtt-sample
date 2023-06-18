import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mqtt_test/config/app_colors.dart';
import 'package:mqtt_test/home/providers/all_devices_provider.dart';
import 'package:mqtt_test/home/providers/meter_provider.dart';
import 'package:mqtt_test/home/view/add_meter_view.dart';
import 'package:mqtt_test/home/view/profile_view.dart';
import 'package:mqtt_test/home/widgets/energy_meter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
  int _currentPageIndex = 0;

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
    final allDevicesProvider = Provider.of<AllDevicesProvider>(context);

    //CONNECTING TO MQTT IF DISABLED
    if (!viewModel.isMQTTActive() && allDevicesProvider.getMeters.isNotEmpty) {
      viewModel.initializeMQTT(meterProviderNonListener);
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

                        return LightButton(lightModel: allDevicesProvider.getLights[index]);
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

  @override
  void dispose() {
    viewModel.clearMQTT();
    pageController.dispose();
    super.dispose();
  }
}
