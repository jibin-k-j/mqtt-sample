import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_test/config/app_colors.dart';
import 'package:mqtt_test/home/providers/meter_provider.dart';
import 'package:mqtt_test/home/widgets/energy_meter.dart';
import 'package:mqtt_test/util/mqtt_configuration.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../view_model/home_view_model.dart';
import '../widgets/light_button.dart';

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
    List<Widget> meterView = [];
    final meterProviderNonListener = Provider.of<MeterProvider>(context, listen: false);
    final meterProvider = Provider.of<MeterProvider>(context);

    //CONNECTING TO MQTT IF DISABLED
    if (!viewModel.isMQTTActive()) {
      viewModel.initializeMQTT(meterProviderNonListener);
    }

    //GENERATING METER VIEW
    for (var meter in meterProvider.getAllMeterReadings) {
      meterView.add(EnergyMeter(size: size, meterModel: meter));
    }

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
          CircleAvatar(
            backgroundColor: AppColors.buttonColor,
            child: const Icon(Icons.person_rounded),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
      body: Column(
        children: [
          //Buttons
          SizedBox(
            height: size.height * .2,
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: 4,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0, childAspectRatio: 1 / .35),
                itemBuilder: (BuildContext ctx, int index) {
                  return LightButton();
                }),
          ),
          //Meter
          Expanded(
            child: Column(
              children: [
                Text(
                  'Meter ${_currentPageIndex + 1}',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w600),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    meterProvider.getAllMeterReadings.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CircleAvatar(
                        radius: 5.0,
                        backgroundColor: _currentPageIndex == index ? AppColors.buttonColor : AppColors.surfaceColor,
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

  @override
  void dispose() {
    viewModel.clearMQTT();
    pageController.dispose();
    super.dispose();
  }
}
