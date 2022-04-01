import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  const ExerciseTile(
      {Key? key,
      required this.id,
      required this.order,
      required this.orderColor,
      required this.onDissmiss,
      required this.onAboveClick,
      required this.onBelowClick,
      required this.belowAndAboveButtonsEnabled})
      : super(key: key);

  final int id;
  final String order;
  final Color orderColor;
  final Function(int id) onDissmiss;
  final Function(int id) onAboveClick;
  final Function(int id) onBelowClick;
  final bool belowAndAboveButtonsEnabled;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id.toString()),
      onDismissed: (direction) {
        onDissmiss(id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
                      'Exercise $id',
                    ),
                  ],
                ),
              ],
            ),
            if (belowAndAboveButtonsEnabled)
              Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    type: MaterialType.button,
                    child: IconButton(
                      onPressed: () {
                        onAboveClick(id);
                      },
                      icon: const Icon(Icons.arrow_upward),
                      tooltip: "Merge with exercise above",
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () {
                        onBelowClick(id);
                      },
                      icon: const Icon(Icons.arrow_downward),
                      tooltip: "Merge with exercise below",
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
