import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
    EasyLoading.show(
        status: status,
        indicator: indicator,
        maskType: maskType,
        dismissOnTap: dismissOnTap);
  }

  static dismiss() {
    EasyLoading.dismiss();
  }

  static showToast(
    String status, {
    Duration? duration,
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
