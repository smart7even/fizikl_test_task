import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  const ExerciseTile({
    Key? key,
    required this.title,
    required this.order,
    required this.orderColor,
  }) : super(key: key);

  final String title;
  final String order;
  final Color orderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
          color: const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: orderColor,
                // color: Color(0xFF5187C3),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              'Set $order',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontFamily: "Lato"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
