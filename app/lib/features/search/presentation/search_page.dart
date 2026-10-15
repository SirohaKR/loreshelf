// 통합 검색 — 캐릭터(어디서 찾았는지)·세계관·프로젝트. 입력이 멈추면(디바운스) 검색 (캐릭터 목록 화면과 같은 방식)
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/utils/labels.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_note.dart';
import '../../../core/widgets/section_card.dart';
import '../../characters/presentation/character_detail_page.dart';
import '../../characters/presentation/widgets/portrait.dart';
import '../../projects/presentation/project_detail_page.dart';
import '../domain/search_result.dart';
import 'search_provider.dart';

const _matchedLabel = {'name': '이름', 'tagline': '소개·대사', 'tag': '태그', 'field': '기본 정보', 'quote': '대표 대사', 'body': '배경 이야기'};

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  static Future<void> open(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SearchPage()));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctl = useTextEditingController();
    final typed = useValueListenable(ctl);
    final query = useState('');

    useEffect(() {
      final timer = Timer(const Duration(milliseconds: 300), () => query.value = typed.text.trim());
      return timer.cancel;
    }, [typed.text]);

    final results = query.value.isEmpty ? null : ref.watch(searchProvider(query.value));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: ctl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '이름·소개·태그·기본 정보·대사·배경 이야기 찾기',
            border: InputBorder.none,
            suffixIcon: typed.text.isEmpty ? null : IconButton(icon: const Icon(Icons.close, size: 18), onPressed: ctl.clear),
          ),
        ),
      ),
      body: query.value.isEmpty
          ? const EmptyNote('찾을 말을 입력해 보세요')
          : AsyncValueView(
              value: results!,
              onRetry: () => ref.invalidate(searchProvider(query.value)),
              builder: (r) => ListView(
                padding: const EdgeInsets.all(AppSpacing.page),
                children: [
                  Text("'${query.value}' 검색 결과 ${r.total}건", style: TextStyle(color: context.colors.muted)),
                  const SizedBox(height: 14),
                  if (r.total == 0) const EmptyNote('찾은 게 없어요. 다른 말로 찾아보세요.'),
                  if (r.characters.isNotEmpty) ...[
                    SectionCard(title: '캐릭터 ${r.characters.length}', child: _CharacterHits(r.characters)),
                    const SizedBox(height: 16),
                  ],
                  if (r.worlds.isNotEmpty) ...[
                    SectionCard(title: '세계관 ${r.worlds.length}', child: _WorldHits(r.worlds)),
                    const SizedBox(height: 16),
                  ],
                  if (r.projects.isNotEmpty) SectionCard(title: '프로젝트 ${r.projects.length}', child: _ProjectHits(r.projects)),
                ],
              ),
            ),
    );
  }
}

class _CharacterHits extends StatelessWidget {
  const _CharacterHits(this.hits);
  final List<SearchCharacterHit> hits;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final c in hits) ...[
            if (c != hits.first) const Divider(height: 1),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                width: 40,
                height: 40,
                child: Portrait(name: c.name, themeColor: c.themeColor, assetId: c.portraitAssetId, fontSize: 14),
              ),
              title: Text(c.name),
              subtitle: Text(c.tagline?.isNotEmpty == true ? c.tagline! : (c.nameEn ?? '')),
              trailing: Wrap(
                spacing: 4,
                children: [
                  AppChip('${_matchedLabel[c.matchedIn] ?? c.matchedIn}에서 찾음'),
                  if ((c.projectName ?? '').isNotEmpty) AppChip(c.projectName!, tone: Tone.accent),
                ],
              ),
              onTap: () => CharacterDetailPage.open(context, c.id),
            ),
          ],
        ],
      );
}

class _WorldHits extends StatelessWidget {
  const _WorldHits(this.hits);
  final List<SearchWorldHit> hits;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final w in hits) ...[
            if (w != hits.first) const Divider(height: 1),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(w.name),
              subtitle: (w.summary ?? '').isEmpty ? null : Text(w.summary!),
            ),
          ],
        ],
      );
}

class _ProjectHits extends StatelessWidget {
  const _ProjectHits(this.hits);
  final List<SearchProjectHit> hits;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final p in hits) ...[
            if (p != hits.first) const Divider(height: 1),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(p.name),
              subtitle: (p.summary ?? '').isEmpty ? null : Text(p.summary!),
              trailing: AppChip(kindLabel[p.kind] ?? p.kind, tone: kindTone[p.kind] ?? Tone.ok),
              onTap: () => ProjectDetailPage.open(context, p.id),
            ),
          ],
        ],
      );
}
