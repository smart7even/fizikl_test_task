import 'package:flutter/material.dart';

enum ExerciseTileButtonsType { disabled, merge, moveSuperset }

class ExerciseTile extends StatelessWidget {
  const ExerciseTile(
      {Key? key,
      required this.id,
      required this.order,
      required this.orderColor,
      required this.onDissmiss,
      required this.onAboveClick,
      required this.onBelowClick,
      required this.buttonsType})
      : super(key: key);

  final int id;
  final String order;
  final Color orderColor;
  final Function(int id) onDissmiss;
  final Function(int id) onAboveClick;
  final Function(int id) onBelowClick;
  final ExerciseTileButtonsType buttonsType;

  Widget _buildButtons() {
    if (buttonsType == ExerciseTileButtonsType.disabled) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Material(
          color: Colors.transparent,
          type: MaterialType.button,
          child: IconButton(
            padding: EdgeInsets.all(5),
            onPressed: () {
              onAboveClick(id);
            },
            icon: Icon(
              Icons.arrow_upward,
              color: buttonsType == ExerciseTileButtonsType.merge
                  ? Colors.black
                  : Colors.blue,
            ),
            tooltip: buttonsType == ExerciseTileButtonsType.merge
                ? "Merge with exercise above"
                : "Move superset up",
          ),
        ),
        Material(
          color: Colors.transparent,
          child: IconButton(
            padding: EdgeInsets.all(5),
            onPressed: () {
              onBelowClick(id);
            },
            icon: Icon(
              Icons.arrow_downward,
              color: buttonsType == ExerciseTileButtonsType.merge
                  ? Colors.black
                  : Colors.blue,
            ),
            tooltip: buttonsType == ExerciseTileButtonsType.merge
                ? "Merge with exercise below"
                : "Move superset down",
          ),
        )
      ],
    );
  }

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
        constraints: const BoxConstraints(maxHeight: 52),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exercise $id',
                    ),
                  ],
                ),
              ],
            ),
            _buildButtons()
          ],
        ),
      ),
    );
  }
}
