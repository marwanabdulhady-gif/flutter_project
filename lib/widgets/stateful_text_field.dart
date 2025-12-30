import 'package:flutter/material.dart';

class StatefulTextField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final InputDecoration? decoration;

  const StatefulTextField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.decoration,
  });

  @override
  State<StatefulTextField> createState() => _StatefulTextFieldState();
}

class _StatefulTextFieldState extends State<StatefulTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: widget.decoration,
      onChanged: widget.onChanged,
    );
  }
}
