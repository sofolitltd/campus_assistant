//
import 'package:flutter/material.dart';

Column courseInfo(String title, value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
      // SizedBox(width: 8),
      Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          // color: Colors.black87,
        ),
      ),
    ],
  );
}
