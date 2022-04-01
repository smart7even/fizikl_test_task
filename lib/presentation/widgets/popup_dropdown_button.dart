import 'package:flutter/material.dart';

class PopupMenuItemData {
  final String title;
  final VoidCallback onPressed;
  final Widget icon;

  PopupMenuItemData({
    required this.title,
    required this.onPressed,
    required this.icon,
  });
}

class PopupDropdownButton extends StatelessWidget {
  const PopupDropdownButton({Key? key, required this.popupItems})
      : super(key: key);

  final List<PopupMenuItemData> popupItems;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (newStr) {},
      itemBuilder: (BuildContext context) {
        return popupItems.map((PopupMenuItemData choice) {
          return PopupMenuItem<String>(
            value: choice.title,
            child: Row(
              children: [
                choice.icon,
                const SizedBox(
                  width: 10,
                ),
                Text(
                  choice.title,
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
