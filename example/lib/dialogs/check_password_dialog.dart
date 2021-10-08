import 'dart:developer';

import 'package:example/dialogs/app_dialog.dart';
import 'package:example/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:subsocial_flutter_auth/subsocial_flutter_auth.dart';

class CheckPasswordDialog extends AppDialog {
  final AuthAccount _account;

  const CheckPasswordDialog(this._account, {Key? key})
      : super(hookWidget: true);

  @override
  String get title => 'Check Password';

  @override
  Widget buildContent(BuildContext context, ValueNotifier<bool> loadingNotifier,
      ValueNotifier<String?> errorNotifier) {
    final auth = sl.get<SubsocialAuth>();
    final passwordController = useTextEditingController();
    final isLoading = useValueListenable(loadingNotifier);
    return Column(
      children: [
        TextField(
          controller: passwordController,
          enabled: !isLoading,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        AppDialogActionButton(
          label: 'Check',
          loadingNotifier: loadingNotifier,
          action: () async {
            final password = passwordController.text;
            if (password.isEmpty) {
              errorNotifier.value = 'Password cannot be empty';
              return;
            }
            loadingNotifier.value = true;
            try {
              final isCorrect = await auth.verifyPassword(_account, password);
              if (isCorrect) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password is correct')));
              } else {
                errorNotifier.value = 'incorrect password';
              }
            } catch (e, stk) {
              errorNotifier.value = e.toString();
              log(
                'error while verifing password',
                error: e,
                stackTrace: stk,
              );
            }
            loadingNotifier.value = false;
          },
        )
      ],
    );
  }
}
