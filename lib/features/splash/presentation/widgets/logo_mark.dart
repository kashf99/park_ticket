import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.color});
  final Color? color ;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          SvgPicture.asset(
            'assets/icons/park_ticket_logo.svg',
            height: 60.h,
            width: 60.h,
            colorFilter: ColorFilter.mode(
              color??
              const Color.fromARGB(255, 239, 246, 248),
              BlendMode.srcIn,
            ),
            fit: BoxFit.contain,
          ),
          SizedBox(width: 4.w),
          Column(
            children: [
              Text(
                'Park Ticket',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: color?? Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1.5),
                      blurRadius: 10,
                      color: const Color.fromARGB(255, 1, 25, 36),
                    ),
                  ],
                ),
              ),
              Text(
                'Adventure Begins Here',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: color?? Colors.white,
                       shadows: [
                    Shadow(
                      offset: const Offset(0, 1.5),
                      blurRadius: 10,
                      color: const Color.fromARGB(255, 1, 25, 36),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
