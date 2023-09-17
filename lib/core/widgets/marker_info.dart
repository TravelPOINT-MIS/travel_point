import 'package:flutter/material.dart';

class MarkerInfo extends StatelessWidget {
  final String title;
  final String snippet;
  final List<String>? types;
  final dynamic rating;

  const MarkerInfo({
    Key? key,
    required this.title,
    required this.snippet,
    this.types,
    this.rating,
  }) : super(key: key);

  String formatLocationTypeName(String name) {
    final parts = name.split('_');
    final formattedName = parts
        .map((part) => part.substring(0, 1).toUpperCase() + part.substring(1))
        .join(' ');
    return formattedName;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4.0),
            Center(
              child: Text(
                snippet ?? "", // Additional information
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ),
            if (types != null && types!.isNotEmpty) ...[
              const SizedBox(height: 4.0),
              Center(
                child: Text(
                  'Types: ${types!.map(formatLocationTypeName).join(", ")}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
            if (rating != null) ...[
              const SizedBox(height: 4.0),
              Center(
                child: Text(
                  'Rating: ${rating.toString()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
