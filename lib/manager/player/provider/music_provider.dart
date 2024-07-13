import 'package:flutter/material.dart';
import 'package:flutter_rainbow_music/model/song_detail_model.dart';
import 'package:audioplayers/audioplayers.dart';

abstract class MusicProvider {
  String? fetchHash();
  String? fetchSongUrl();
  String? fetchCoverUrl();
  String? fetchSongName();
  String? fetchSingerName();
  double fetchPlayProgress();
  bool fetchIsSelected();
  PlayerState fetchPlayState();
  Color fetchThemeColor();

  void updateSongDetail(SongDetailModel value);
  void updatePlayState(PlayerState state);
  void updateSelected(bool selected);

  MusicProvider clone();
}
