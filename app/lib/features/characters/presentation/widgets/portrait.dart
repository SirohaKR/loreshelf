// 초상화 — 이미지가 있으면 썸네일, 없으면 테마색(또는 파스텔) + 실루엣 + 이름 앞 두 글자 (웹 portrait()와 같음)
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/utils/color_utils.dart';

class Portrait extends ConsumerWidget {
  const Portrait({
    super.key,
    required this.name,
    this.themeColor,
    this.assetId,
    this.fontSize = 26,
    this.badge,
  });

  final String name;
  final String? themeColor;
  final int? assetId;
  final double fontSize;

  /// 오른쪽 위에 겹쳐 놓을 작은 칩 (예: '전용')
  final Widget? badge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiClientProvider);
    final shade = Colors.black.withValues(alpha: .08);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.portrait),
      child: ColoredBox(
        color: themeColorOf(themeColor) ?? pastel(name),
        child: LayoutBuilder(
          builder: (context, box) {
            final w = box.maxWidth;
            return Stack(
              fit: StackFit.expand,
              children: [
                if (assetId != null)
                  Image.network(
                    api.assetUrl(assetId!),
                    headers: api.imageHeaders,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  )
                else ...[
                  // 실루엣: 머리(동그라미) + 어깨(반원) — CSS .pt.empty::before / ::after
                  Positioned(
                    left: w * .35,
                    width: w * .30,
                    top: box.maxHeight * .24,
                    height: w * .30,
                    child: DecoratedBox(decoration: BoxDecoration(color: shade, shape: BoxShape.circle)),
                  ),
                  Positioned(
                    left: w * .18,
                    width: w * .64,
                    bottom: -w * .64 * .18,
                    height: w * .64,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: shade,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(w * .32)),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      name.characters.take(2).toString(),
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withValues(alpha: .45),
                      ),
                    ),
                  ),
                ],
                if (badge != null) Positioned(top: 8, right: 8, child: badge!),
              ],
            );
          },
        ),
      ),
    );
  }
}
