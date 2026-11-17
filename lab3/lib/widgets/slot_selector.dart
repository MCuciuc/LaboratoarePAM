import 'package:flutter/material.dart';
import 'package:lab2/data/models/appointment.dart';
import 'package:lab2/widgets/selectable_chip.dart';

class SlotSelector extends StatelessWidget {
  const SlotSelector({
    super.key,
    required this.slots,
    required this.selectedId,
    required this.onSelected,
  });

  final List<SlotOption> slots;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final chips = [
      for (final slot in slots)
        SelectableChip(
          label: slot.label,
          selected: slot.id == selectedId,
          onTap: () => onSelected(slot.id),
        ),
    ];

    if (slots.length <= 3) {
      return Row(
        children: [
          for (var i = 0; i < chips.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: chips[i]),
          ],
        ],
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < chips.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            SizedBox(width: 110, child: chips[i]),
          ],
        ],
      ),
    );
  }
}
