import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rainbow_music/base/widgets/audio_bars_animation.dart';

class SongItemView extends StatelessWidget {
  final String coverUrl;
  final String songName;
  final String singerName;
  final bool isSelected;
  final int? ranking;
  final double? borderRadius;
  final EdgeInsets? padding;
  final VoidCallback onTap;
  final VoidCallback favoriteTap;

  const SongItemView({
    super.key,
    required this.coverUrl,
    required this.songName,
    required this.singerName,
    required this.isSelected,
    this.ranking,
    this.borderRadius,
    this.padding,
    required this.onTap,
    required this.favoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white70,
          borderRadius: borderRadius != null
              ? BorderRadius.circular(borderRadius!)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (ranking != null) ...[
              Text(
                ranking.toString(),
                style: TextStyle(
                    color: ranking! <= 3 ? Colors.red : Colors.black54,
                    fontSize: ranking! <= 3 ? 20 : 16,
                    fontWeight:
                        ranking! <= 3 ? FontWeight.w600 : FontWeight.w400),
              ),
              const SizedBox(width: 10),
            ],
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: Colors.white70,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: coverUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                              color: Colors.pink.shade100, strokeWidth: 1),
                        ),
                        errorWidget: (context, error, stackTrace) => const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.black12),
                      ),
                      if (isSelected) ...[
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: const AudioBarsAnimation(
                            itemCount: 3,
                          ),
                        )
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(songName,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 15,
                          color: isSelected ? Colors.blue : Colors.black,
                          overflow: TextOverflow.ellipsis)),
                  Text(singerName,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.blue : Colors.black54,
                          overflow: TextOverflow.ellipsis))
                ],
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                color: Colors.black26,
                icon: const Icon(Icons.favorite_border),
                onPressed: favoriteTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
