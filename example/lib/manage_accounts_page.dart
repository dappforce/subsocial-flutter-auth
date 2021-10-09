import 'dart:developer';

import 'package:example/dialogs/change_name_dialog.dart';
import 'package:example/dialogs/change_password_dialog.dart';
import 'package:example/dialogs/check_password_dialog.dart';
import 'package:example/dialogs/set_signer_dialog.dart';
import 'package:example/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:subsocial_flutter_auth/subsocial_flutter_auth.dart';

class ManageAccountsPage extends StatelessWidget {
  const ManageAccountsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SubsocialAuth auth = sl.get();
    auth.update();
    return StateNotifierBuilder<AuthState>(
      stateNotifier: auth,
      builder: (context, state, child) {
        log('State updated');
        return Scaffold(
          appBar: AppBar(
            title: Text('Manage Accounts'),
          ),
          body: state.accounts.isEmpty
              ? Center(
                  child: Text('There is no accounts'),
                )
              : Column(
                  children: [
                    const CurrentSignerChecker(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.accounts.length,
                        itemBuilder: (context, index) {
                          final account = state.accounts[index];
                          final isActive = account == state.activeAccount;
                          return AccountWidget(
                              isActive: isActive, account: account);
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

enum AccountWidgetAction {
  setSigner,
  setActiveAccount,
  unsetActiveAccount,
  removeAccount,
  checkPassword,
  changePassword,
  changeName,
}

class AccountWidget extends HookWidget {
  const AccountWidget({
    Key? key,
    required this.isActive,
    required this.account,
  }) : super(key: key);

  final bool isActive;
  final AuthAccount account;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    return ListTile(
      leading: isLoading.value
          ? const CircularProgressIndicator()
          : Icon(
              isActive ? Icons.person : Icons.person_outline,
              color: isActive ? Theme.of(context).primaryColor : Colors.grey,
            ),
      title: Text(
        account.localName + (isActive ? ' (Active)' : ''),
        style: TextStyle(
          fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      subtitle: Text(account.publicKey),
      trailing: PopupMenuButton<AccountWidgetAction>(
        itemBuilder: (context) => [
          const PopupMenuItem(
            child: Text("Set signer"),
            value: AccountWidgetAction.setSigner,
          ),
          if (isActive)
            const PopupMenuItem(
              child: Text("Unset active"),
              value: AccountWidgetAction.unsetActiveAccount,
            )
          else
            const PopupMenuItem(
              child: Text("Set active"),
              value: AccountWidgetAction.setActiveAccount,
            ),
          const PopupMenuItem(
            child: Text("Remove"),
            value: AccountWidgetAction.removeAccount,
          ),
          const PopupMenuItem(
            child: Text("Check password"),
            value: AccountWidgetAction.checkPassword,
          ),
          const PopupMenuItem(
            child: Text("Change password"),
            value: AccountWidgetAction.changePassword,
          ),
          const PopupMenuItem(
            child: Text("Change name"),
            value: AccountWidgetAction.changeName,
          ),
        ],
        enabled: !isLoading.value,
        onSelected: (value) => _handleAction(
          context,
          value,
          isLoading,
        ),
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    AccountWidgetAction action,
    ValueNotifier<bool> loadingNotifier,
  ) async {
    final SubsocialAuth auth = sl.get();
    loadingNotifier.value = true;
    switch (action) {
      case AccountWidgetAction.setActiveAccount:
        await auth.setActiveAccount(account);
        break;
      case AccountWidgetAction.unsetActiveAccount:
        await auth.unsetActiveAccount();
        break;
      case AccountWidgetAction.removeAccount:
        await auth.removeAccount(account);
        break;
      case AccountWidgetAction.checkPassword:
        await CheckPasswordDialog(account).show(context);
        break;
      case AccountWidgetAction.changePassword:
        await ChangePasswordDialog(account).show(context);
        break;
      case AccountWidgetAction.changeName:
        await ChangeNameDialog(account).show(context);
        break;
      case AccountWidgetAction.setSigner:
        await SetSignerDialog(account).show(context);
        break;
    }

    loadingNotifier.value = false;
  }
}

class CurrentSignerChecker extends HookWidget {
  const CurrentSignerChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = sl.get<SubsocialAuth>();
    final singerNotifier = useState<AuthAccount?>(null);
    final loadingNotifier = useState(false);
    useEffect(() {
      _fetchCurrentSigner(singerNotifier, loadingNotifier);
    }, []);
    final InlineSpan signerTextSpan;
    if (singerNotifier.value == null) {
      signerTextSpan = const TextSpan(text: 'not set');
    } else {
      final account = singerNotifier.value!;
      signerTextSpan = TextSpan(children: [
        TextSpan(
          text: 'Name: ${account.localName}\n',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: account.publicKey),
      ]);
    }
    return ListTile(
      leading: Icon(
        Icons.mode_edit,
        color: Theme.of(context).primaryColor,
      ),
      title: const Text(
        'Current Signer',
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text.rich(signerTextSpan),
      trailing: loadingNotifier.value
          ? const CircularProgressIndicator()
          : IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  _fetchCurrentSigner(singerNotifier, loadingNotifier),
            ),
    );
  }

  Future<String> _fetchCurrentSignerAccount(
    ValueNotifier<String?> singerNotifier,
    ValueNotifier<bool> loadingNotifier,
  ) async {
    final auth = sl.get<SubsocialAuth>();
    loadingNotifier.value = true;
    final account = (await auth.getAccounts())
        .where(
          (account) => account.publicKey == singerNotifier.value,
        )
        .first;
    loadingNotifier.value = false;
    return '${account.localName}\n\n${account.publicKey}';
  }

  Future<void> _fetchCurrentSigner(
    ValueNotifier<AuthAccount?> singerNotifier,
    ValueNotifier<bool> loadingNotifier,
  ) async {
    final auth = sl.get<SubsocialAuth>();
    loadingNotifier.value = true;
    final signerPublicKey = await auth.currentSignerId();
    singerNotifier.value = (await auth.getAccounts())
        .where(
          (account) => account.publicKey == signerPublicKey,
        )
        .toIList()
        .firstOrNull;
    loadingNotifier.value = false;
  }
}
