// 갤러리 탭 — 정사각 썸네일 격자(Sliver), 누르면 원본을 크게(확대·이동 가능)
// 맨 앞 칸 = 이미지 추가, 크게 본 창에서 ★대표로 / 갤러리에서 빼기
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/utils/pick_image.dart';
import '../../../../core/widgets/app_error_toast.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../domain/character.dart';
import '../character_edit_provider.dart';

class CharacterGallery extends ConsumerWidget {
  const CharacterGallery(this.ch, {super.key});
  final CharacterDetail ch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiClientProvider);
    final c = context.colors;
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: ch.gallery.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) return _AddTile(ch.id);
        final img = ch.gallery[i - 1];
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.thumb),
          child: Material(
            color: c.surface2,
            child: InkWell(
              onTap: () => _openFull(context, ref, api.assetUrl(img.id, thumb: false), api.imageHeaders, img),
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

  void _openFull(BuildContext context, WidgetRef ref, String url, Map<String, String> headers, GalleryImage img) {
    final actions = ref.read(characterActionsProvider);
    final isPortrait = img.id == ch.portraitAssetId;
    // 창을 닫고 나서 일을 하고, 실패하면 알림
    Future<void> run(BuildContext dialog, Future<void> Function() work) async {
      Navigator.pop(dialog);
      try {
        await work();
      } catch (e) {
        if (context.mounted) showAppErrorToast(context, e);
      }
    }

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
            Positioned(
              left: 12,
              right: 12,
              bottom: 10,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (img.originalName != null) AppChip(img.originalName!),
                  if (!isPortrait)
                    FilledButton.tonal(
                      onPressed: () => run(context, () => actions.setPortrait(ch.id, img.id)),
                      child: const Text('★ 대표로'),
                    ),
                  FilledButton.tonal(
                    onPressed: () async {
                      final ok = await showConfirmationDialog(
                        context,
                        title: '갤러리에서 뺄까요?',
                        message: isPortrait ? '대표 이미지도 비워져요.' : null,
                        confirmLabel: '빼기',
                      );
                      if (ok && context.mounted) await run(context, () => actions.removeImage(ch.id, img.id));
                    },
                    child: const Text('갤러리에서 빼기'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 격자 맨 앞 칸 — 눌러서 이미지 고르기 → 올리기 → 갤러리에 넣기
class _AddTile extends HookConsumerWidget {
  const _AddTile(this.characterId);
  final int characterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = useState(false);
    final c = context.colors;
    Future<void> add() async {
      final picked = await pickImage();
      if (picked == null) return;
      busy.value = true;
      try {
        await ref.read(characterActionsProvider).addImage(characterId, picked.bytes, picked.name);
      } catch (e) {
        if (context.mounted) showAppErrorToast(context, e);
      } finally {
        if (context.mounted) busy.value = false;
      }
    }

    return Material(
      color: c.surface2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.thumb),
        side: BorderSide(color: c.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.thumb),
        onTap: busy.value ? null : add,
        child: Center(
          child: busy.value
              ? const CircularProgressIndicator()
              : Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.add_photo_alternate_outlined, color: c.muted, size: 32),
                  const SizedBox(height: 6),
                  Text('이미지 추가', style: TextStyle(color: c.muted, fontSize: 13)),
                ]),
        ),
      ),
    );
  }
}
