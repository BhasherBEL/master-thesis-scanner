import 'package:flutter/material.dart';
import 'package:thesis_scanner/entry.dart';

class SaveButton extends StatelessWidget {
  final List<Entry> entries;
  final String? filename;

  const SaveButton({
    super.key,
    required this.entries,
    this.filename,
  });

  Future<void> _handleSave(BuildContext context) async {
    try {
      await Entry.shareCSV(entries, filename: filename);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleSave(context),
      child: const Text('Save to CSV'),
    );
  }
}
