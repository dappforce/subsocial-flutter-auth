import 'dart:developer';

import 'package:example/dialogs/app_dialog.dart';
import 'package:example/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:subsocial_flutter_auth/subsocial_flutter_auth.dart';

class ChangePasswordDialog extends AppDialog {
  final AuthAccount _account;

  const ChangePasswordDialog(this._account, {Key? key})
      : super(hookWidget: true);

  @override
  String get title => 'Change Password';

  @override
  Widget buildContent(BuildContext context, ValueNotifier<bool> loadingNotifier,
      ValueNotifier<String?> errorNotifier) {
    final passwordController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final isLoading = useValueListenable(loadingNotifier);
    return Column(
      children: [
        TextField(
          controller: passwordController,
          enabled: !isLoading,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        TextField(
          controller: newPasswordController,
          enabled: !isLoading,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'New Password'),
        ),
        AppDialogActionButton(
          label: 'Change Password',
          loadingNotifier: loadingNotifier,
          action: () async {
            final auth = sl.get<SubsocialAuth>();

            final password = passwordController.text;
            final newPassword = newPasswordController.text;
            if (password.isEmpty || newPassword.isEmpty) {
              errorNotifier.value = 'Fields cannot be empty';
              return;
            }
            loadingNotifier.value = true;
            try {
              final newAcc =
                  await auth.changePassword(_account, password, newPassword);
              if (newAcc != null) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password have changed')));
              } else {
                errorNotifier.value = 'incorrect old password';
              }
            } catch (e, stk) {
              errorNotifier.value = e.toString();
              log(
                'error while changing password',
                error: e,
                stackTrace: stk,
              );
            }
            loadingNotifier.value = false;
          },
        ),
      ],
    );
  }
}
