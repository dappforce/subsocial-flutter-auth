import 'package:example/create_account_page.dart';
import 'package:example/manage_accounts_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subsocial Auth Example'),
      ),
      body: ListView(
        children: [
          HomePageItem(
            text: 'Create new account',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const CreateAccountPage(CreateAccountPageType.generate);
              }));
            },
          ),
          HomePageItem(
            text: 'Import account account',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const CreateAccountPage(CreateAccountPageType.import);
              }));
            },
          ),
          HomePageItem(
            text: 'Manage accounts',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const ManageAccountsPage();
              }));
            },
          )
        ],
      ),
    );
  }
}

class HomePageItem extends StatelessWidget {
  final String text;
  final GestureTapCallback? onTap;
  const HomePageItem({
    Key? key,
    required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.navigate_next),
      ),
    );
  }
}
