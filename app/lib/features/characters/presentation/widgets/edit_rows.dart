// 캐릭터 편집 화면의 조각들 — 입력칸, 테마색, 줄(기본 정보·성격 축·대사) 목록, 태그 입력
// 줄 위젯은 값(row)을 받아 그리고, 바뀌면 onChanged(새 값)를 부를 뿐 — 상태는 편집 화면 하나가 들고 있다.
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/color_utils.dart';
import '../../domain/character_draft.dart';

/// 이름표가 붙은 한 줄 입력칸. initialValue만 주고 값은 onChanged로 올려 보낸다
class EditText extends StatelessWidget {
  const EditText({super.key, required this.label, required this.initial, required this.onChanged, this.hint, this.maxLength});
  final String label;
  final String initial;
  final String? hint;
  final int? maxLength;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          initialValue: initial,
          maxLength: maxLength,
          decoration: InputDecoration(labelText: label, hintText: hint, counterText: ''),
          onChanged: onChanged,
        ),
      );
}

/// 테마색: 정해 둔 색 + "없음"
class ThemeColorPicker extends StatelessWidget {
  const ThemeColorPicker({super.key, required this.value, required this.onChanged});
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final choices = [...themeColorChoices, if (value != null && !themeColorChoices.contains(value!.toUpperCase())) value!];
    Widget dot(String? hex) {
      final selected = hex?.toUpperCase() == value?.toUpperCase();
      return Tooltip(
        message: hex ?? '색 안 씀',
        child: InkResponse(
          onTap: () => onChanged(hex),
          radius: 20,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: hex == null ? c.surface2 : themeColorOf(hex, alpha: 0xFF),
              shape: BoxShape.circle,
              border: Border.all(color: selected ? c.text : c.line, width: selected ? 2.5 : 1),
            ),
            child: hex == null ? Icon(Icons.block, size: 16, color: c.muted) : null,
          ),
        ),
      );
    }

    return Wrap(spacing: 10, runSpacing: 10, children: [dot(null), for (final h in choices) dot(h)]);
  }
}

/// 줄 목록 + 아래 "추가" 버튼
class RowList extends StatelessWidget {
  const RowList({super.key, required this.children, required this.addLabel, required this.onAdd});
  final List<Widget> children;
  final String addLabel;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...children,
          OutlinedButton(onPressed: onAdd, child: Text(addLabel)),
        ],
      );
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton(this.onPressed);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) =>
      IconButton(onPressed: onPressed, icon: const Icon(Icons.close, size: 18), tooltip: '지우기', visualDensity: VisualDensity.compact);
}

class _SecretCheck extends StatelessWidget {
  const _SecretCheck({required this.value, required this.onChanged, this.label = '🔒 비밀'});
  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => onChanged(!value),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Checkbox(value: value, onChanged: (v) => onChanged(v ?? false), visualDensity: VisualDensity.compact),
          Text(label, style: const TextStyle(fontSize: 13)),
        ]),
      );
}

InputDecoration _dense(String hint) => InputDecoration(hintText: hint, isDense: true, counterText: '');

/// 기본 정보 한 줄: 항목 | 값 | 🔒 | ✕
class FieldRow extends StatelessWidget {
  const FieldRow({super.key, required this.row, required this.onChanged, required this.onDelete});
  final FieldDraft row;
  final ValueChanged<FieldDraft> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          SizedBox(
            width: 110,
            child: TextFormField(
              initialValue: row.label,
              maxLength: 40,
              decoration: _dense('항목 (예: 나이)'),
              onChanged: (v) => onChanged(row.copyWith(label: v)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: row.value,
              maxLength: 2000,
              decoration: _dense('값'),
              onChanged: (v) => onChanged(row.copyWith(value: v)),
            ),
          ),
          _SecretCheck(value: row.isSecret, label: '🔒', onChanged: (v) => onChanged(row.copyWith(isSecret: v))),
          _DeleteButton(onDelete),
        ]),
      );
}

/// 성격 축 한 줄: 왼쪽 | 오른쪽 | ✕ / 아래에 슬라이더.
/// 오른쪽이 비면 "한쪽짜리 — 강도 n%"로 보여 준다
class TraitRow extends StatelessWidget {
  const TraitRow({super.key, required this.row, required this.onChanged, required this.onDelete});
  final TraitDraft row;
  final ValueChanged<TraitDraft> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final oneSided = row.rightLabel.trim().isEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(children: [
        Row(children: [
          Expanded(
            child: TextFormField(
              initialValue: row.leftLabel,
              maxLength: 20,
              decoration: _dense('왼쪽 (예: 내향)'),
              onChanged: (v) => onChanged(row.copyWith(leftLabel: v)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: row.rightLabel,
              maxLength: 20,
              decoration: _dense('반대 성격 (예: 외향)'),
              onChanged: (v) => onChanged(row.copyWith(rightLabel: v)),
            ),
          ),
          _DeleteButton(onDelete),
        ]),
        Row(children: [
          Expanded(
            child: Slider(
              value: row.valuePercent.toDouble(),
              max: 100,
              divisions: 100,
              label: '${row.valuePercent}%',
              onChanged: (v) => onChanged(row.copyWith(valuePercent: v.round())),
            ),
          ),
          SizedBox(
            width: 96,
            child: Text(oneSided ? '강도 ${row.valuePercent}%' : '${row.valuePercent}%',
                textAlign: TextAlign.end, style: TextStyle(fontSize: 12, color: context.colors.muted)),
          ),
        ]),
      ]),
    );
  }
}

/// 대표 대사 한 줄: 대사 | 상황 | 🔒 | ✕
class QuoteRow extends StatelessWidget {
  const QuoteRow({super.key, required this.row, required this.onChanged, required this.onDelete});
  final QuoteDraft row;
  final ValueChanged<QuoteDraft> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: row.body,
              maxLength: 1000,
              decoration: _dense('대사'),
              onChanged: (v) => onChanged(row.copyWith(body: v)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: row.situation,
              maxLength: 100,
              decoration: _dense('상황 (예: 첫 만남)'),
              onChanged: (v) => onChanged(row.copyWith(situation: v)),
            ),
          ),
          _SecretCheck(value: row.isSecret, label: '🔒', onChanged: (v) => onChanged(row.copyWith(isSecret: v))),
          _DeleteButton(onDelete),
        ]),
      );
}

/// 태그 칩 + 입력칸. Enter 또는 쉼표를 치면 칩이 된다
class TagEditor extends HookWidget {
  const TagEditor({super.key, required this.tags, required this.onAdd, required this.onRemove});
  final List<String> tags;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final input = useTextEditingController();
    final focus = useFocusNode();
    void commit() {
      if (input.text.trim().isEmpty) return;
      onAdd(input.text);
      input.clear();
    }

    // 입력칸을 벗어날 때 남은 글자도 태그로 (저장 버튼을 바로 눌러도 빠지지 않게)
    useEffect(() {
      void onFocus() {
        if (!focus.hasFocus) commit();
      }

      focus.addListener(onFocus);
      return () => focus.removeListener(onFocus);
    }, [focus]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (tags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Wrap(spacing: 6, runSpacing: 6, children: [
              for (final t in tags) InputChip(label: Text('#$t'), onDeleted: () => onRemove(t), deleteButtonTooltipMessage: '태그 빼기'),
            ]),
          ),
        TextField(
          controller: input,
          focusNode: focus,
          maxLength: 40,
          decoration: _dense('#은발 #복선 …'),
          onChanged: (v) {
            if (v.endsWith(',')) commit();
          },
          onSubmitted: (_) {
            commit();
            focus.requestFocus(); // Enter 뒤에도 계속 입력
          },
        ),
      ],
    );
  }
}
