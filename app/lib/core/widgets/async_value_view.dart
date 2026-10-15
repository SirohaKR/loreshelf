// AsyncValue(로딩 / 에러 / 데이터) 세 가지 경우를 한 번에 그려 주는 도우미.
// 로그인이 풀린 경우(401)는 여기서 따로 처리하지 않는다 — ApiClient가 알려 주면
// 로그인 상태(authSessionProvider)가 알아서 로그인 화면으로 돌려보낸다.
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({super.key, required this.value, required this.builder, this.onRetry});

  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    // 새로고침 중에도 이전 데이터를 그대로 보여 준다 (깜빡임 방지)
    if (value.hasValue) return builder(value.requireValue);
    if (value.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.page),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${value.error}', textAlign: TextAlign.center, style: TextStyle(color: context.colors.danger)),
              if (onRetry != null) ...[
                const SizedBox(height: 12),
                OutlinedButton(onPressed: onRetry, child: const Text('다시 시도')),
              ],
            ],
          ),
        ),
      );
    }
    return const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()));
  }
}

/// CustomScrollView 안에 넣는 버전 — 값이 있으면 [sliver]를, 아니면 로딩/에러를 상자에 담아서
class AsyncSliverView<T> extends StatelessWidget {
  const AsyncSliverView({super.key, required this.value, required this.sliver, this.onRetry});

  final AsyncValue<T> value;
  final Widget Function(T data) sliver;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (value.hasValue) return sliver(value.requireValue);
    return SliverToBoxAdapter(
      child: AsyncValueView(value: value, onRetry: onRetry, builder: (_) => const SizedBox.shrink()),
    );
  }
}
