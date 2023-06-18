import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSnackBar {
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10.0),
        content: Row(
          children: [
            const Icon(Icons.error_rounded, size: 20.0, color: Colors.white),
            const SizedBox(width: 5.0),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        )));
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10.0),
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              size: 20.0,
              color: Colors.white,
            ),
            const SizedBox(width: 5.0),
            Text(
              message,
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ],
        )));
  }
}
