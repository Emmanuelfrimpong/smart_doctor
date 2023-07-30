import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

class HomeCard extends StatelessWidget {
  const HomeCard(
      {super.key,
      this.title,
      this.subtitle,
      this.image,
      this.onTap,
      this.color,
      this.alert = false});
  final String? title;
  final String? subtitle;
  final String? image;
  final Function? onTap;
  final Color? color;
  final bool alert;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (alert)
              RippleAnimation(
                color: primaryColor,
                delay: const Duration(milliseconds: 300),
                repeat: true,
                minRadius: 50,
                ripplesCount: 3,
                duration: const Duration(milliseconds: 6 * 300),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      image!,
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
              ),
            if (!alert)
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    image!,
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
            Text(
              title!,
              maxLines: 1,
              style: normalText(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              height: 5,
              thickness: 1,
              color: Colors.grey,
              indent: 10,
              endIndent: 10,
            ),
          ],
        ),
      ),
    );
  }
}
