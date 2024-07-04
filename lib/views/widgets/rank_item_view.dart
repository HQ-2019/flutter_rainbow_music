import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rainbow_music/model/rank_item_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RankItemView extends StatelessWidget {
  final VoidCallback onTap;

  final RankItemModel model;
  final double? width;
  final double? height;

  const RankItemView({
    super.key,
    required this.onTap,
    required this.model,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
            color: Colors.white70,
            width: width,
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Colors.white70,
                        child: CachedNetworkImage(
                          imageUrl: model?.albumImg9 ?? '',
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => const Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.black),
                        ),
                      )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 5, right: 10, bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(model?.rankname ?? '',
                            maxLines: 1,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis)),
                        const SizedBox(height: 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: model?.songs
                                  ?.take(3)
                                  .map(
                                    (songModel) => Text.rich(
                                      TextSpan(
                                        text:
                                            '${(model.songs?.indexOf(songModel) ?? 0) + 1} ',
                                        style: const TextStyle(
                                          color: Colors.black26,
                                          fontSize: 14,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: songModel.songName,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' - ${songModel.singerName}',
                                          ),
                                        ],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                  .toList() ??
                              [],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
