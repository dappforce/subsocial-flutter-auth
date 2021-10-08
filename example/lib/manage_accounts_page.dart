import 'dart:developer';

import 'package:example/change_name_dialog.dart';
import 'package:example/change_password_dialog.dart';
import 'package:example/check_password_dialog.dart';
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
        log(state.accounts.toString());
        return Scaffold(
          appBar: AppBar(
            title: Text('Manage Accounts'),
          ),
          body: state.accounts.isEmpty
              ? Center(
                  child: Text('There is no accounts'),
                )
              : ListView.builder(
                  itemCount: state.accounts.length,
                  itemBuilder: (context, index) {
                    final account = state.accounts[index];
                    final isActive = account == state.activeAccount;
                    return AccountWidget(isActive: isActive, account: account);
                  },
                ),
        );
      },
    );
  }
}

enum AccountWidgetAction {
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

    log('acc ${account.hashCode}');

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
        await CheckPasswordDialog.show(context, account);
        break;
      case AccountWidgetAction.changePassword:
        await ChangePasswordDialog.show(context, account);
        break;
      case AccountWidgetAction.changeName:
        await ChangeNameDialog.show(context, account);
        break;
    }

    loadingNotifier.value = false;
  }
}
