import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_page/home_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          Get.to(() => HomeScreen());
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xff131a24),
              image: DecorationImage(
                  image: NetworkImage(
                      'https://data.textstudio.com/output/sample/animated/5/4/9/5/quote-1-15945.gif'),
                  fit: BoxFit.fitWidth)),
        ),
      ),
    );
  }
}
