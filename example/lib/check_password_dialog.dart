import 'dart:developer';

import 'package:example/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:subsocial_flutter_auth/subsocial_flutter_auth.dart';

class CheckPasswordDialog extends HookWidget {
  final AuthAccount _account;

  const CheckPasswordDialog(this._account, {Key? key}) : super(key: key);

  static Future<void> show(BuildContext context, AuthAccount account) async {
    return showDialog(
      context: context,
      builder: (context) => CheckPasswordDialog(account),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = sl.get<SubsocialAuth>();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);
    final errorText = useState<String?>(null);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Check Password',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              enabled: !isLoading.value,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            Row(
              children: [
                Spacer(),
                TextButton.icon(
                  onPressed: isLoading.value
                      ? null
                      : () async {
                          final password = passwordController.text;
                          if (password.isEmpty) {
                            errorText.value = 'Password cannot be empty';
                            return;
                          }
                          isLoading.value = true;
                          try {
                            final isCorrect =
                                await auth.verifyPassword(_account, password);
                            if (isCorrect) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Password is correct')));
                            } else {
                              errorText.value = 'incorrect password';
                            }
                          } catch (e, stk) {
                            errorText.value = e.toString();
                            log(
                              'error while verifing password',
                              error: e,
                              stackTrace: stk,
                            );
                          }
                          isLoading.value = false;
                        },
                  label: const Text('Check'),
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
