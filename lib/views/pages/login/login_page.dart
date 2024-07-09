import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:flutter_rainbow_music/model/user_model.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loginButtonEnabled = false;
  bool _checkboxEnabled = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // 监听键盘的输入
    _phoneController.addListener(() {
      print('手机号码输入 ${_phoneController.text}');
      _updateLoginButtonState();
    });
    // 监听键盘的输入
    _passwordController.addListener(() {
      print('密码码输入 ${_passwordController.text}');
      _updateLoginButtonState();
    });
  }

  void _updateLoginButtonState() {
    bool enabled = true;
    if (!_checkboxEnabled) {
      enabled = false;
    }
    // 验证手机号
    if (_phoneController.text.length != 11 ||
        !GetUtils.isPhoneNumber(_phoneController.text)) {
      enabled = false;
    }
    // 验证密码
    if (!GetUtils.hasMatch(_passwordController.text, r'^[a-zA-Z0-9]{6,18}$')) {
      enabled = false;
    }

    if (_loginButtonEnabled == enabled) {
      return;
    }
    setState(() {
      _loginButtonEnabled = enabled;
    });
  }

  void _login() {
    final userModel = UserModel(
        phone: _phoneController.text,
        nickname: '彩虹音乐${Random().nextInt(1000000) + 10000}');
    UserManager().login(userModel);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 禁止Scaffold根据键盘调整自身
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: MediaQuery.of(context).padding.top + 50),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Colors.blueAccent.withOpacity(0.3),
                Colors.pink.withOpacity(0.3)
              ])),
          child: Column(
            children: [
              _titleView(),
              const SizedBox(height: 60),
              _editView(),
              const SizedBox(height: 30),
              _agreementView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '登录',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
            ),
            Text.rich(
              TextSpan(
                text: '欢迎来到',
                style: TextStyle(fontSize: 16, letterSpacing: 1),
                children: [
                  TextSpan(
                    text: '彩虹音乐',
                    style: TextStyle(
                        color: Colors.pinkAccent, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 30,
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _editView() {
    return Column(
      children: [
        _textField(
            controller: _phoneController,
            icon: Icons.phone_android,
            hintText: '请输入手机号',
            keyboardType: TextInputType.phone,
            lengthLimit: 11),
        const SizedBox(height: 16),
        _textField(
            controller: _passwordController,
            icon: Icons.keyboard,
            hintText: '请输入6~18位密码',
            keyboardType: TextInputType.text,
            lengthLimit: 18),
        const SizedBox(height: 50),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: TextButton(
            onPressed: !_loginButtonEnabled
                ? null
                : () {
                    _login();
                  },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.pinkAccent.withOpacity(0.3);
                }
                return Colors.pinkAccent;
              }),
              foregroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.white.withOpacity(0.5);
                }
                return Colors.white;
              }),
            ),
            child: const Text(
              '登录',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textField(
      {TextEditingController? controller,
      IconData? icon,
      String? hintText,
      TextInputType? keyboardType,
      int? lengthLimit}) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black45),
          const SizedBox(width: 4),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              cursorColor: Colors.pinkAccent,
              style: const TextStyle(fontSize: 16),
              inputFormatters: [LengthLimitingTextInputFormatter(lengthLimit)],
              decoration: InputDecoration.collapsed(
                hintText: hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _agreementView() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 30,
              height: 30,
              padding: const EdgeInsets.only(bottom: 9.0),
              child: Checkbox(
                tristate: true,
                value: _checkboxEnabled,
                activeColor: Colors.pinkAccent,
                side: const BorderSide(
                  color: Colors.black54,
                  width: 1,
                ),
                onChanged: (value) {
                  setState(() {
                    _checkboxEnabled = !_checkboxEnabled;
                    _updateLoginButtonState();
                  });
                },
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: '登录即表示同意彩虹音乐',
                  style: const TextStyle(color: Colors.black54, fontSize: 14.0),
                  children: <TextSpan>[
                    TextSpan(
                      text: '《注册协议》',
                      style: const TextStyle(color: Colors.pinkAccent),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('点击注册协议');
                        },
                    ),
                    const TextSpan(text: '和'),
                    TextSpan(
                      text: '《隐私政策》',
                      style: const TextStyle(color: Colors.pinkAccent),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('点击隐私政策');
                        },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
