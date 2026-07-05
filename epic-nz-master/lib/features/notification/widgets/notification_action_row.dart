import 'package:flutter/material.dart';

class NotificationActionRow extends StatelessWidget {
  const NotificationActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Accept'),
          ),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: () {},
          child: Text(
            'Dismiss',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
