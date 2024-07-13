import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rainbow_music/base/widgets/audio_bars_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SongCoverImageView extends StatelessWidget {
  const SongCoverImageView({
    super.key,
    required this.coverUrl,
    this.showAudioBars = false,
    this.aspectRatio = 1.0,
    this.borderRadius = 5.0,
  });

  final String coverUrl;
  final bool showAudioBars;
  final double aspectRatio;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: coverUrl,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
                    color: Colors.pink.shade100, strokeWidth: 1),
              ),
              errorWidget: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  size: 40,
                  color: Colors.black12),
            ),
            if (showAudioBars) ...[
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
    );
  }
}
