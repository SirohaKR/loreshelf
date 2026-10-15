// 로그인 화면 — HookConsumerWidget.
// 입력칸 컨트롤러는 훅(useTextEditingController)으로: 만들기·dispose를 훅이 챙긴다.
// 보내는 중/오류 같은 상태는 loginControllerProvider(LoginState)에서 받아 그린다.
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/api_client_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/brand.dart';
import '../data/auth_repository_impl.dart';
import 'login_provider.dart';
import 'widgets/labeled_field.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final savedUrl = ref.read(authRepositoryProvider).serverUrl;
    final server = useTextEditingController(text: savedUrl.isEmpty ? defaultServerUrl : savedUrl);
    final loginName = useTextEditingController();
    final password = useTextEditingController();
    final state = ref.watch(loginControllerProvider);

    void submit() => ref.read(loginControllerProvider.notifier).submit(
          serverUrl: kIsWeb ? '' : server.text.trim(),
          loginName: loginName.text.trim(),
          password: password.text,
        );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.page),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Brand(),
                      const SizedBox(height: 22),
                      if (!kIsWeb) // 웹은 지금 페이지와 같은 서버를 쓴다
                        LabeledField(
                          label: '서버 주소',
                          child: TextField(
                            controller: server,
                            keyboardType: TextInputType.url,
                            decoration: const InputDecoration(hintText: 'http://localhost:5091'),
                          ),
                        ),
                      LabeledField(
                        label: '아이디',
                        child: TextField(
                          key: const Key('login-name'),
                          controller: loginName,
                          autofillHints: const [AutofillHints.username],
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      LabeledField(
                        label: '비밀번호',
                        child: TextField(
                          key: const Key('login-password'),
                          controller: password,
                          obscureText: true,
                          autofillHints: const [AutofillHints.password],
                          onSubmitted: (_) => submit(),
                        ),
                      ),
                      if (state.error != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                          decoration: BoxDecoration(color: c.dangerSoft, borderRadius: BorderRadius.circular(AppRadii.input)),
                          child: Text(state.error!, style: TextStyle(color: c.danger, fontSize: 13)),
                        ),
                      const SizedBox(height: 6),
                      FilledButton(
                        onPressed: state.submitting ? null : submit,
                        child: Text(state.submitting ? '확인하는 중…' : '로그인'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
