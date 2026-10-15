// Android 뒤로 가기를 맨 처음 화면에서 누르면 바로 꺼지지 않고 "한 번 더 누르면 종료"를 보여 준다.
// 2초 안에 한 번 더 누르면 앱 종료. (데스크톱·웹에서는 뒤로 가기가 없어서 그냥 통과)
// 마지막으로 누른 시각은 이 위젯만의 상태라 useRef 훅에 둔다 — 값이 바뀌어도 다시 그리지 않는 상자.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DoubleBackToExit extends HookWidget {
  const DoubleBackToExit({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final lastPressed = useRef<DateTime?>(null);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final now = DateTime.now();
        if (lastPressed.value != null && now.difference(lastPressed.value!) < const Duration(seconds: 2)) {
          SystemNavigator.pop();
          return;
        }
        lastPressed.value = now;
        ScaffoldMessenger.maybeOf(context)
          ?..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('한 번 더 누르면 종료돼요'), duration: Duration(seconds: 2)));
      },
      child: child,
    );
  }
}
