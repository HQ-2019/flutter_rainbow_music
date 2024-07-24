import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rainbow_music/base/widgets/audio_bars_animation.dart';

class Loading {
  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return EasyLoading.init();
  }

  static show({
    String? status,
    Widget? indicator,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) {
    Widget indicatorView = indicator ??
        const SizedBox(
          height: 30,
          width: 80,
          child: AudioBarsAnimation(itemCount: 5),
        );
    EasyLoading.show(
        status: status,
        indicator: indicatorView,
        maskType: maskType,
        dismissOnTap: dismissOnTap);
  }

  static dismiss() {
    EasyLoading.dismiss();
  }

  static showToast(
    String status, {
    Duration duration = const Duration(seconds: 2),
    EasyLoadingToastPosition? toastPosition,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) {
    EasyLoading.showToast(status,
        duration: duration,
        toastPosition: toastPosition,
        maskType: maskType,
        dismissOnTap: dismissOnTap);
  }
}
