import 'dart:developer';

import 'package:example/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:subsocial_flutter_auth/subsocial_flutter_auth.dart';

enum CreateAccountPageType {
  import,
  generate,
}

class CreateAccountPage extends HookWidget {
  final CreateAccountPageType type;

  const CreateAccountPage(this.type, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isGenerate = type == CreateAccountPageType.generate;
    final SubsocialAuth auth = sl.get();
    final suriController = useTextEditingController();
    final nameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final seedWordsFuture = useMemoized(() async {
      if (!isGenerate) return <String>[].lock;
      return auth.generateMnemonic();
    });
    final seedWordsSnapshot = useFuture(seedWordsFuture);
    final accountCreationLoading = useState(false);
    final errorText = useState<String?>(null);
    final isWordsLoading =
        seedWordsSnapshot.connectionState == ConnectionState.waiting;
    return Scaffold(
      appBar: AppBar(
        title: Text(isGenerate ? 'Create New Account' : 'Import Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: isWordsLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  if (isGenerate)
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      spacing: 5,
                      children: seedWordsSnapshot.data!
                          .map((word) => Chip(
                                label: Text(word),
                              ))
                          .toList(),
                    )
                  else
                    TextField(
                      controller: suriController,
                      decoration: const InputDecoration(labelText: 'Suri'),
                      enabled: !accountCreationLoading.value,
                    ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    enabled: !accountCreationLoading.value,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    enabled: !accountCreationLoading.value,
                  ),
                  accountCreationLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            final suri = isGenerate
                                ? seedWordsSnapshot.data!.join(' ')
                                : suriController.text;
                            final name = nameController.text;
                            final password = passwordController.text;
                            if (name.isEmpty ||
                                password.isEmpty ||
                                suri.isEmpty) {
                              errorText.value = "don't leave fields empty :(";
                              return;
                            }
                            accountCreationLoading.value = true;
                            errorText.value = null;
                            try {
                              await auth.importAccount(
                                localName: name,
                                suri: suri,
                                password: password,
                              );
                              Navigator.of(context).pop();
                            } catch (e, stk) {
                              errorText.value = e.toString();
                              log(
                                'Error while creating account',
                                error: e,
                                stackTrace: stk,
                              );
                            }
                            accountCreationLoading.value = false;
                          },
                          child: const Text('Create account'),
                        ),
                  if (errorText.value != null)
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        errorText.value!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    )
                ],
              ),
      ),
    );
  }
}
