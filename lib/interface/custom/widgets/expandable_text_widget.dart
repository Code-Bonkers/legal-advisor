import 'package:flutter/material.dart';

class ExpandableTextWidget extends StatelessWidget {
  final String data;

  const ExpandableTextWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            data,
            maxLines: 1, // Limit the text to a single line
            overflow: TextOverflow.ellipsis, // Add ellipsis for overflowed text
          ),
        ),
        IconButton(
          icon: const Icon(Icons.expand_more),
          onPressed: () {
            _showFullTextDialog(context, data);
          },
        ),
      ],
    );
  }

  void _showFullTextDialog(BuildContext context, String fullText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Full Text'),
          content: SingleChildScrollView(
            child: Text(fullText),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
