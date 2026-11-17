import 'package:flutter/material.dart';
import 'package:lab2/core/app_colors.dart';

class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    required this.hint,
    required this.query,
    required this.onChanged,
    this.onFilter,
  });

  final String hint;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilter;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(AppSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.query,
        selection: TextSelection.collapsed(offset: widget.query.length),
      );
    }
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
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.search, color: AppColors.muted),
        suffixIcon: widget.onFilter == null
            ? null
            : IconButton(
                tooltip: 'Filter and sort',
                onPressed: widget.onFilter,
                icon: const Icon(Icons.tune, color: AppColors.muted),
              ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
