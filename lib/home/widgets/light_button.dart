import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_test/home/models/light_model.dart';
import 'package:mqtt_test/home/providers/light_provider.dart';
import 'package:mqtt_test/util/mqtt_configuration.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../util/widget_loading.dart';

class LightButton extends StatelessWidget {
  final MQTTClientManager mqttClientManager;
  final LightModel lightModel;

  const LightButton({Key? key, required this.lightModel, required this.mqttClientManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lightProvider = Provider.of<LightProvider>(context);

    dynamic status;
    if (lightProvider.getResponse.isNotEmpty) {
      final data = json.decode(lightProvider.getResponse);
      status = data[lightModel.id];
      log('Status is $status');
    }

    return (lightProvider.getResponse.isEmpty || status == null)
        ? const WidgetLoading.rectangular(width: 80.0, height: 10.0, device: 'light')
        : GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              final response = json.decode(lightProvider.getResponse);

              response[lightModel.id] = status == 1 ? 0 : 1;
              log('response is $response');
              Map<String, dynamic> data = {
                'id': lightModel.productId,
              };
              data.addAll(response);
              String topic = 'onwords/${lightModel.productId}/status';
              dynamic deviceStatus = jsonEncode(data);
              mqttClientManager.publishMessage(topic, deviceStatus);
              log('Published $deviceStatus');
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: status == 1
                    ? [
                        BoxShadow(
                          color: AppColors.buttonColor.withOpacity(.4),
                          offset: const Offset(0, 5),
                        )
                      ]
                    : null,
                color: status == 1 ? AppColors.buttonColor : AppColors.surfaceColor,
                border: Border.all(
                  width: 1,
                  color: Colors.grey.withOpacity(.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'asset/icons/light.svg',
                    width: 25.0,
                    colorFilter: ColorFilter.mode(status == 1 ? Colors.black : Colors.grey, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    lightModel.name,
                    style: GoogleFonts.poppins(
                      color: status == 1 ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
