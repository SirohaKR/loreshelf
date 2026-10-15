// 갤러리 탭 — 정사각 썸네일 격자(Sliver), 누르면 원본을 크게(확대·이동 가능)
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/empty_note.dart';
import '../../domain/character.dart';

class CharacterGallery extends ConsumerWidget {
  const CharacterGallery(this.ch, {super.key});
  final CharacterDetail ch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ch.gallery.isEmpty) return const SliverToBoxAdapter(child: EmptyNote('갤러리에 이미지가 없어요'));
    final api = ref.watch(apiClientProvider);
    final c = context.colors;
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: ch.gallery.length,
      itemBuilder: (context, i) {
        final img = ch.gallery[i];
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.thumb),
          child: Material(
            color: c.surface2,
            child: InkWell(
              onTap: () => _openFull(context, api.assetUrl(img.id, thumb: false), api.imageHeaders, img),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(api.assetUrl(img.id), headers: api.imageHeaders, fit: BoxFit.cover),
                  if (img.id == ch.portraitAssetId)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(6)),
                        child: Text('★ 대표', style: TextStyle(color: c.warn, fontSize: 11)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openFull(BuildContext context, String url, Map<String, String> headers, GalleryImage img) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(AppSpacing.page),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // 두 손가락(또는 휠)로 확대·이동
            InteractiveViewer(maxScale: 5, child: Image.network(url, headers: headers, fit: BoxFit.contain)),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton.filledTonal(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ),
            if (img.originalName != null) Positioned(left: 12, bottom: 10, child: AppChip(img.originalName!)),
          ],
        ),
      ),
    );
  }
}
