import 'package:flutter/material.dart';
import 'package:smart_doctor/styles/colors.dart';

class MedicationType extends StatelessWidget {
  const MedicationType(
      {super.key,
      required this.title,
      this.icon,
      required this.onTap,
      this.isSelected = false});
  final String title;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.white60,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 3))
            ]),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        alignment: Alignment.center,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.black,
                  size: 35,
                ),
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold),
              )
            ]),
      ),
    );
  }
}
