import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common.dart' as Fluttertoast;

const Color redBackground = Color(0xFFA10505);
const Color greyBackground = Color(0xFFF1F1F1);

final TextStyle textAppbar = GoogleFonts.nunito(
    fontSize: 50.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black
);

final TextStyle textProductName = GoogleFonts.nunito(
  fontSize: 50.sp,
  fontWeight: FontWeight.w500,
  color: Colors.black
);

final TextStyle textProductDescription = GoogleFonts.nunito(
    fontSize: 35.sp,
    fontWeight: FontWeight.w200,
    color: Colors.black
);

final TextStyle textProductPrice = GoogleFonts.nunito(
    fontSize: 65.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black
);

final String IP_PORT = "192.168.0.5:9987";