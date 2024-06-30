import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SpecialItemView extends StatelessWidget {
  final VoidCallback onTap;
  final String coverUrl;
  final String specialName;

  const SpecialItemView({
    super.key,
    required this.onTap,
    required this.coverUrl,
    required this.specialName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 100,
        height: 150,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: double.infinity,
            height: 95,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: Colors.white24,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: coverUrl,
                  errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.black),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(specialName, maxLines: 2, overflow: TextOverflow.ellipsis),
        ]),
      ),
    );
  }
}
