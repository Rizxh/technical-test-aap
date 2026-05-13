import 'package:flutter/material.dart';

class TodoSearchBar extends StatelessWidget {
  const TodoSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'Cari berdasarkan title...',
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: onChanged,
    );
  }
}
