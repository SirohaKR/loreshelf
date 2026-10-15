// 화면 아래에 잠깐 뜨는 오류 알림 (예: 당겨서 새로고침이 실패했을 때)
import 'package:flutter/material.dart';

void showAppErrorToast(BuildContext context, Object error) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$error'), duration: const Duration(seconds: 3)));
}

/// RefreshIndicator용: 새로 받아 오다 실패하면 화면은 그대로 두고 알림만
Future<void> refreshOrToast(BuildContext context, Future<Object?> Function() refresh) async {
  try {
    await refresh();
  } catch (e) {
    if (context.mounted) showAppErrorToast(context, e);
  }
}
