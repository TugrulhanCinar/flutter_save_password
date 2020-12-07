import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/folder_container_widget.dart';
import 'package:flutter_save_password/app/pages/add_folder_page.dart';
import 'package:flutter_save_password/app/pages/details_page.dart';
import 'package:flutter_save_password/app/pages/search.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:provider/provider.dart';
import 'favorite_accounts.dart';

class HomePage extends StatelessWidget {
  final appBarTitle = "Title";
  final String userName = "Tuğrulhan Çınar";
  final String userNickName = "tugrul@tugrul.com";
  final String favoriteTitleText = "Favoriler";
  final String proileTitleText = "Profil";
  List<Folder> folders;
  List<Account> allAccounts;
  Folder currentFolder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //todo
      drawer: buildDrawer(context),
      appBar: context.appBar(appBarTitle, actions: appBarActions(context)),
      floatingActionButton: buildFloatingActionButton(context),
      body: Consumer<PasswordSaveViewModel>(builder: (context, cart, child) {
        if (cart.state == PasswordState.Busy) {
          return buildCircularProgressIndicator;
        } else {
          folders = cart.folders;
          allAccounts = cart.allAccount;
          if (folders.length > 1) {
            return Center(
              child: Text("Hiç kullanıcı yok "),
            );
          } else {
            return buildGridView();
          }
        }
      }),
    );
  }

  void wait() async {
    await Future.delayed(Duration(seconds: 1));
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 90,
            child: buildDrawerBody(context),
          ),
          Expanded(
            flex: 10,
            child: signOutButton(context),
          ),
        ],
      ),
    );
  }

  ListView buildDrawerBody(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        buildDrawerHeader(context),
        drawerProfileItem,
        context.customLowDivider,
        drawerFavoriteItem(context),
        context.customLowDivider,
      ],
    );
  }

  RaisedButton signOutButton(BuildContext context) {
    return RaisedButton(
      color: Colors.white,
      onPressed: sigonOutButtonOnTap(context),
      child: signOutButtonRow,
    );
  }

  Row get signOutButtonRow {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Çıkış yap"),
        Icon(Icons.exit_to_app),
      ],
    );
  }

  ListTile get drawerProfileItem {
    return ListTile(
      title: Text(proileTitleText),
      leading: Icon(Icons.account_circle),
      onTap: () => print("Profil"),
    );
  }

  ListTile drawerFavoriteItem(BuildContext context) {
    return ListTile(
      title: Text(favoriteTitleText),
      leading: Icon(Icons.save),
      onTap: drawerFavoriteItemOnTap(context),
    );
  }

  DrawerHeader buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: drawerHeaderChilderen(context),
      ),
      decoration: BoxDecoration(color: Colors.deepOrange),
    );
  }

  List<Widget> drawerHeaderChilderen(BuildContext context) {
    return [
      ListTile(
        title: Text(
          userName,
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.white),
        ),
        subtitle: Text(
          userNickName,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: Colors.white),
        ),
      ),
    ];
  }

  Center get buildCircularProgressIndicator =>
      Center(child: CircularProgressIndicator());

  GridView buildGridView() {
    return GridView.builder(
      itemCount: folders.length,
      itemBuilder: (context, index) {
        currentFolder = folders[index];
        return buildFolderContainer(index, context);
      },
      gridDelegate: buildSliverGridDelegateWithFixedCrossAxisCount,
    );
  }

  FolderContainer buildFolderContainer(int index, BuildContext context) {
    return FolderContainer(
      color: currentFolder.folderColor,
      containerName: currentFolder.folderName,
      onTap: folderContainerOnTap(context, index),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount
      get buildSliverGridDelegateWithFixedCrossAxisCount =>
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3);

  FloatingActionButton buildFloatingActionButton(BuildContext context) =>
      FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
        onPressed: floatingActionButtonOnTap(context),
      );

  List<Widget> appBarActions(BuildContext context) =>
      [appBarSearchAction(context)];

  IconButton appBarSearchAction(BuildContext context) => IconButton(
        icon: Icon(Icons.search),
        onPressed: appBarSearchActionOnTap(context),
      );

  appBarSearchActionOnTap(BuildContext context) => showSearch(
        context: context,
        delegate: PasswordSearch(
          context,
        ),
      );

  folderContainerOnTap(BuildContext context, int index) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailsPage(folderIndex: index)),
      );

  floatingActionButtonOnTap(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddFolderPage()),
      );

  drawerFavoriteItemOnTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoriteAccountsPage(),
      ),
    );
  }

  sigonOutButtonOnTap(BuildContext context) {
    print("sigonOutButtonOnTap");
  }
}
