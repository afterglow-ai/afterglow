import 'package:flutter/material.dart';

class MemoryCard extends StatelessWidget {
  final String title;
  final String body;
  final String? imageUrl;
  final String createdAt;
  final String? voiceUrl;

  const MemoryCard({
    super.key,
    required this.title,
    required this.body,
    required this.createdAt,
    this.imageUrl,
    this.voiceUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null) Image.network(imageUrl!),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          Text(
            body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[700]),
          ),
          SizedBox(height: 8),
          Text(createdAt, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
