import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_save_password/app/common__widget/custom_alert_dialog.dart';
import 'package:flutter_save_password/app/common__widget/custom_app_bar.dart';
import 'package:flutter_save_password/app/common__widget/folder_container_widget.dart';
import 'package:flutter_save_password/init/navigation/navigation_constants.dart';
import 'package:flutter_save_password/init/navigation/navigation_services.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:flutter_save_password/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'search.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final String appBarTitle = "App bar Title";
  final String drawerFavoriteTitle = "Favoriler";
  final String createRandomPasswordTitle = "Şifre Oluştur";
  final String profileFavoriteTitle = "Profile";
  final String signOutFavoriteTitle = "Çıkış yap";
  List<Folder> folderList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      floatingActionButton: buildFloatingActionButton(context),
      appBar: buildCustomAppBar(context),
      body: buildBody,
    );
  }

  Consumer<PasswordSaveViewModel> get buildBody =>
      Consumer<PasswordSaveViewModel>(
        builder: (context, cart, child) {
          cart.folders ?? cart.fetchFolders();
          if (cart.state == PasswordState.Busy) {
            return circularProgressIndicator;
          } else {
            folderList = cart.folders;
            return buildGridView;
          }
        },
      );

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(child: buildDrawerBody(context)),
          signOutPageIconButton(context),
        ],
      ),
    );
  }

  ListView buildDrawerBody(BuildContext context) {
    return ListView(
      children: [
        buildDrawerHeader(context),
        favoritePageIconButton(context),
        profilePageIconButton(context),
      ],
    );
  }

  ListTile profilePageIconButton(BuildContext context) {
    return ListTile(
      title: Text(profileFavoriteTitle),
      leading: Icon(Icons.person),
      onTap: () {
        Navigator.pop(context);
        NavigationServices.instance.navigateToPage(path: NavigationConstans.PROFILE_PAGE);
      },
    );
  }

  ListTile favoritePageIconButton(BuildContext context) {
    return ListTile(
      title: Text(drawerFavoriteTitle),
      leading: Icon(Icons.favorite),
      onTap: () {
        Navigator.pop(context);
        NavigationServices.instance.navigateToPage(path: NavigationConstans.FAVORITE_PAGE);
      },
    );
  }

  ListTile signOutPageIconButton(BuildContext context) {
    return ListTile(
      title: Text(signOutFavoriteTitle),
      leading: Icon(Icons.exit_to_app),
      onTap: () {
        try {
          Provider.of<UserViewModel>(context, listen: false).signOut();
          NavigationServices.instance.navigateToPageClear(path: NavigationConstans.LANDING_PAGE);

        } catch (e) {
          MyCustomDialog(
            title: Center(child: Text("Hata")),
            content: Text("Bir hata oluştu: " + e.message.toString()),
            actions: [
              Container(
                padding: context.paddingAllLowMedium,
                width: context.width,
                child: RaisedButton(
                  color: Colors.red,
                  shape: roundedRectangleBorder(context),
                  child: Text("Tamam"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ).goster(context);
        }
      },
    );
  }

  Widget buildDrawerHeader(BuildContext context) =>
      DrawerHeader(child: buildDrawerHeaderItem(context));

  Column buildDrawerHeaderItem(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildNameAndMail(context),
      );

  List<Widget> buildNameAndMail(BuildContext context) => [
        buildNameText(context),
        buildMailText(context),
      ];

  Text buildNameText(BuildContext context) =>
      Text(Provider.of<UserViewModel>(context).user.userName,
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: Theme.of(context).colorScheme.genelRenk,
              ));

  Text buildMailText(BuildContext context) => Text(
        Provider.of<UserViewModel>(context).user.userEmail,
        style: Theme.of(context).textTheme.caption,
      );

  GridView get buildGridView => GridView.builder(
        gridDelegate: buildSliverGridDelegateWithFixedCrossAxisCount,
        itemCount: folderList.length,
        itemBuilder: (context, index) {
          return buildFolderContainer(index, context);
        },
      );

  Widget buildFolderContainer(index, context) => FolderContainer(
        color: folderList[index].folderColor,
        containerName: folderList[index].folderName,
        onTap: () {
          NavigationServices.instance.navigateToPage(path: NavigationConstans.FOLDER_DETAIL_PAGE,data: index);
        },
      );

  Widget get circularProgressIndicator =>
      Center(child: CircularProgressIndicator());

  CustomAppBar buildCustomAppBar(BuildContext context) =>
      CustomAppBar(appBarTitle, actions: appBarActions(context));

  List<Widget> appBarActions(BuildContext context) => [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            showSearch(
              context: context,
              delegate: AccountSearch(context),
            );
          },
        )
      ];

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.genelRenk,
      onPressed: () {
        NavigationServices.instance.navigateToPage(path: NavigationConstans.ADDING_FOLDER_PAGE);
      },
      child: Icon(Icons.add),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount
      get buildSliverGridDelegateWithFixedCrossAxisCount =>
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3);

  RoundedRectangleBorder roundedRectangleBorder(BuildContext context) =>
      RoundedRectangleBorder(borderRadius: context.borderHighRadiusHCircular);
}
