import 'package:flutter_screenutil/flutter_screenutil.dart';

double get screenWidth => ScreenUtil().screenWidth;
double get screenHeight => ScreenUtil().screenHeight;

class AppScreen {
  static double get width => screenWidth;
  static double get height => screenHeight;
}
