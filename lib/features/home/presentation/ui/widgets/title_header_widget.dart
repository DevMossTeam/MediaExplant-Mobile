import 'package:flutter/material.dart';

Widget titleHeader(String title, [String? subTitle]) {
  return Row(
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      if (subTitle != null) ...[
        const SizedBox(width: 10),
        Text(
          subTitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    ],
  );
}
