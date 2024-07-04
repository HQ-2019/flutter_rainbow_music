import 'package:flutter_rainbow_music/model/song_info_model.dart';
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

  void updateSongDetail(SongInfoModel value);
  void updatePlayState(PlayerState state);
  void updateSelected(bool selected);

  MusicProvider clone();
}
