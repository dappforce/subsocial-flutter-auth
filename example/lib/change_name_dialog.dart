import 'dart:developer';

import 'package:example/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:subsocial_flutter_auth/subsocial_flutter_auth.dart';

class ChangeNameDialog extends HookWidget {
  final AuthAccount _account;

  const ChangeNameDialog(this._account, {Key? key}) : super(key: key);

  static Future<void> show(BuildContext context, AuthAccount account) async {
    return showDialog(
      context: context,
      builder: (context) => ChangeNameDialog(account),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = sl.get<SubsocialAuth>();
    final nameController = useTextEditingController();
    final isLoading = useState(false);
    final errorText = useState<String?>(null);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Change Name',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              enabled: !isLoading.value,
              decoration: const InputDecoration(labelText: 'New name'),
            ),
            Row(
              children: [
                Spacer(),
                TextButton.icon(
                  onPressed: isLoading.value
                      ? null
                      : () async {
                          final name = nameController.text;
                          if (name.isEmpty) {
                            errorText.value = 'Name cannot be empty';
                            return;
                          }
                          isLoading.value = true;
                          try {
                            await auth.changeName(_account, name);
                            Navigator.of(context).pop();
                          } catch (e, stk) {
                            errorText.value = e.toString();
                            log(
                              'error while changing name',
                              error: e,
                              stackTrace: stk,
                            );
                          }
                          isLoading.value = false;
                        },
                  label: const Text('Change'),
                  icon: isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
            if (errorText.value != null)
              Text(
                errorText.value!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              )
          ],
        ),
      ),
    );
  }
}
