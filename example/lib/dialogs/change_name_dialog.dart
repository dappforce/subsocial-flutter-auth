import 'dart:developer';

import 'package:example/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:subsocial_flutter_auth/subsocial_flutter_auth.dart';

import 'app_dialog.dart';

class ChangeNameDialog extends AppDialog<TextEditingController> {
  final AuthAccount _account;

  const ChangeNameDialog(this._account) : super(hookWidget: true);

  @override
  String get title => "Change Name";

  @override
  Widget buildContent(
    BuildContext context,
    ValueNotifier<bool> loadingNotifier,
    ValueNotifier<String?> errorNotifier,
  ) {
    final nameController = useTextEditingController();
    final isLoading = useValueListenable(loadingNotifier);
    return Column(
      children: [
        TextField(
          controller: nameController,
          enabled: !isLoading,
          decoration: const InputDecoration(labelText: 'New name'),
        ),
        AppDialogActionButton(
          label: 'Change',
          loadingNotifier: loadingNotifier,
          action: () async {
            final auth = sl.get<SubsocialAuth>();
            final name = nameController.text;
            if (name.isEmpty) {
              errorNotifier.value = 'Name cannot be empty';
              return;
            }
            loadingNotifier.value = true;
            try {
              await auth.changeName(_account, name);
              Navigator.of(context).pop();
            } catch (e, stk) {
              errorNotifier.value = e.toString();
              log(
                'error while changing name',
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
