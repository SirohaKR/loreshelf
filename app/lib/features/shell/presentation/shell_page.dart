// 메인 틀 — 넓은 화면은 왼쪽 메뉴(NavigationRail), 좁은 화면(폰)은 아래 탭(NavigationBar).
// 지금 어느 탭인지는 이 화면만 알면 되니까 Riverpod이 아니라 useState(훅)로 들고 있는다.
// (이 기능은 서버 데이터가 없어서 data/·domain/ 없이 presentation/만 있다)
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/brand.dart';
import '../../../core/widgets/double_back_to_exit.dart';
import '../../auth/domain/user.dart';
import '../../characters/presentation/character_list_page.dart';
import '../../home/presentation/home_page.dart';
import '../../projects/presentation/project_list_page.dart';
import '../../search/presentation/search_page.dart';
import '../../trash/presentation/trash_page.dart';
import 'widgets/shell_actions.dart';

class ShellPage extends HookWidget {
  const ShellPage({super.key, required this.user});
  final User user;

  static const _tabs = [
    (icon: Icons.home_outlined, on: Icons.home, label: '홈'),
    (icon: Icons.people_outline, on: Icons.people, label: '캐릭터'),
    (icon: Icons.folder_outlined, on: Icons.folder, label: '프로젝트'),
  ];

  @override
  Widget build(BuildContext context) {
    final tab = useState(0);

    // IndexedStack: 세 화면을 모두 살려 두고 하나만 보여 줌 → 탭을 오가도 스크롤·필터가 그대로
    final body = IndexedStack(
      index: tab.value,
      children: [
        HomePage(onOpenTab: (i) => tab.value = i),
        const CharacterListPage(),
        const ProjectListPage(),
      ],
    );
    final actions = [
      IconButton(tooltip: '검색', icon: const Icon(Icons.search), onPressed: () => SearchPage.open(context)),
      IconButton(tooltip: '휴지통', icon: const Icon(Icons.delete_outline), onPressed: () => TrashPage.open(context)),
      const ThemeToggleButton(),
      LogoutButton(displayName: user.displayName),
    ];

    return DoubleBackToExit(
      child: LayoutBuilder(
        builder: (context, box) {
          if (box.maxWidth >= 840) {
            final extended = box.maxWidth >= 1100;
            return Scaffold(
              body: Row(
                children: [
                  NavigationRail(
                    extended: extended,
                    minExtendedWidth: 236, // CSS --side-w
                    selectedIndex: tab.value,
                    onDestinationSelected: (i) => tab.value = i,
                    leading: Padding(padding: const EdgeInsets.fromLTRB(8, 8, 8, 18), child: Brand(compact: !extended)),
                    trailing: Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(mainAxisSize: MainAxisSize.min, children: actions),
                        ),
                      ),
                    ),
                    destinations: [
                      for (final t in _tabs)
                        NavigationRailDestination(icon: Icon(t.icon), selectedIcon: Icon(t.on), label: Text(t.label)),
                    ],
                  ),
                  VerticalDivider(width: 1, color: context.colors.line),
                  Expanded(child: body),
                ],
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(title: const Brand(), actions: actions),
            body: body,
            bottomNavigationBar: NavigationBar(
              selectedIndex: tab.value,
              onDestinationSelected: (i) => tab.value = i,
              destinations: [
                for (final t in _tabs) NavigationDestination(icon: Icon(t.icon), selectedIcon: Icon(t.on), label: t.label),
              ],
            ),
          );
        },
      ),
    );
  }
}
