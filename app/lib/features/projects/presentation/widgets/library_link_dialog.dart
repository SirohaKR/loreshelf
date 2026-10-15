// 서재에서 연결 창 — 웹 projects.js의 linkModal과 같은 흐름:
// 아직 이 프로젝트에 없는 서재 캐릭터를 이름으로 찾아 하나 고르고, 역할(선택)을 적어 연결한다.
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../characters/domain/character.dart';
import '../project_edit_provider.dart';

/// 고르면 (캐릭터 번호, 역할)을, 취소하면 null을 돌려준다
Future<({int characterId, String? role})?> showLibraryLinkDialog(BuildContext context, {required Set<int> alreadyIn}) =>
    showDialog(context: context, builder: (_) => LibraryLinkDialog(alreadyIn: alreadyIn));

class LibraryLinkDialog extends HookConsumerWidget {
  const LibraryLinkDialog({super.key, required this.alreadyIn});
  final Set<int> alreadyIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(libraryCharactersForLinkingProvider);
    final filter = useTextEditingController();
    final q = useValueListenable(filter).text.trim().toLowerCase();
    final picked = useState<int?>(null);
    final role = useTextEditingController();
    final c = context.colors;

    final available = (library.value ?? const <CharacterSummary>[]).where((ch) => !alreadyIn.contains(ch.id)).toList();
    final shown = q.isEmpty ? available : available.where((ch) => ch.name.toLowerCase().contains(q)).toList();

    return AlertDialog(
      title: const Text('서재에서 연결', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: filter,
              decoration: const InputDecoration(hintText: '이름으로 찾기', prefixIcon: Icon(Icons.search), isDense: true),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: switch (library) {
                AsyncError(:final error) when !library.hasValue => Text('$error', style: TextStyle(color: c.danger)),
                _ when !library.hasValue => const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                _ when available.isEmpty => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      '연결할 서재 캐릭터가 없어요. 서재 캐릭터는 저장 위치가 "공용 서재"인 캐릭터예요.',
                      style: TextStyle(color: c.muted),
                    ),
                  ),
                _ when shown.isEmpty => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text("'$q'에 맞는 캐릭터가 없어요", style: TextStyle(color: c.muted)),
                  ),
                _ => ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 320),
                    child: RadioGroup<int>(
                      groupValue: picked.value,
                      onChanged: (v) => picked.value = v,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: shown.length,
                        itemBuilder: (_, i) {
                          final ch = shown[i];
                          return RadioListTile<int>(
                            value: ch.id,
                            dense: true,
                            title: Text(ch.name),
                            subtitle: (ch.tagline ?? '').isEmpty ? null : Text(ch.tagline!),
                          );
                        },
                      ),
                    ),
                  ),
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: role,
              maxLength: 30,
              decoration: const InputDecoration(labelText: '역할 (선택)', hintText: '주인공, NPC, 보스 …', isDense: true, counterText: ''),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
        FilledButton(
          onPressed: picked.value == null
              ? null
              : () => Navigator.pop(context, (characterId: picked.value!, role: role.text.trim().isEmpty ? null : role.text.trim())),
          child: const Text('연결'),
        ),
      ],
    );
  }
}
