// 메뉴 아래쪽(또는 상단바)의 버튼 두 개 — 라이트/다크 전환, 로그아웃(확인 창)
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/theme_mode_provider.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../auth/presentation/auth_session_provider.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    return IconButton(
      tooltip: '라이트/다크 전환',
      icon: Icon(brightness == Brightness.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      onPressed: () => ref.read(appThemeModeProvider.notifier).toggle(brightness),
    );
  }
}

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key, required this.displayName});
  final String displayName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: '로그아웃 ($displayName)',
      icon: const Icon(Icons.logout),
      onPressed: () async {
        final ok = await showConfirmationDialog(context, title: '로그아웃할까요?', confirmLabel: '로그아웃');
        if (ok) await ref.read(authSessionProvider.notifier).logout();
      },
    );
  }
}
