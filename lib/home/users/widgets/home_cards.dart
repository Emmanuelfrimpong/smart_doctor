import 'package:flutter/material.dart';
import 'package:smart_doctor/styles/styles.dart';

class HomeCard extends StatelessWidget {
  const HomeCard(
      {super.key,
      this.title,
      this.subtitle,
      this.image,
      this.onTap,
      this.color});
  final String? title;
  final String? subtitle;
  final String? image;
  final Function? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.44,
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color ?? Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image!,
                width: 100,
                height: 80,
              ),
              const SizedBox(height: 5),
              Text(
                title!,
                style: normalText(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 5, thickness: 1, color: Colors.grey),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: normalText(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
