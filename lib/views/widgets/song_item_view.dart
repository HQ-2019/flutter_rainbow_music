import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rainbow_music/base/widgets/audio_bars_animation.dart';
import 'package:flutter_rainbow_music/base/widgets/song_cover_image_view.dart';

class SongItemView extends StatelessWidget {
  final String coverUrl;
  final String songName;
  final String singerName;
  final bool isSelected;
  final bool isFavorite;
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
    required this.isFavorite,
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
            SongCoverImageView(coverUrl: coverUrl, showAudioBars: isSelected),
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
                icon: isFavorite
                    ? const Icon(Icons.favorite, color: Colors.pinkAccent)
                    : const Icon(Icons.favorite_border, color: Colors.black26),
                onPressed: favoriteTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
