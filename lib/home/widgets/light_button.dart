import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/app_colors.dart';

class LightButton extends StatelessWidget {
  const LightButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.buttonColor.withOpacity(.4),
            offset: const Offset(0, 5),
          )
        ],
        color: AppColors.buttonColor,
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
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          const SizedBox(width: 10.0),
          Text(
            'Light',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
            ),
          )
        ],
      ),
    );
  }
}
