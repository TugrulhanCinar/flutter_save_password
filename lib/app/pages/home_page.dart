import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_save_password/app/common__widget/custom_alert_dialog.dart';
import 'package:flutter_save_password/app/common__widget/custom_app_bar.dart';
import 'package:flutter_save_password/app/common__widget/folder_container_widget.dart';
import 'file:///E:/flutterProject/flutter_save_password/lib/app/pages/add/adding_folder.dart';
import 'package:flutter_save_password/app/pages/favorite_page.dart';
import 'file:///E:/flutterProject/flutter_save_password/lib/app/pages/details/folder_detail_page.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:flutter_save_password/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'landing_page.dart';
import 'profile_page.dart';
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
        buildContainerDrawerHeader(context),
        favoritePageIconButton(context),
        profilePageIconButton(context),
      ],
    );
  }

  Container buildContainerDrawerHeader(BuildContext context) {
    return Container(
      child: buildDrawerHeader(context),
      color: Colors.red,
    );
  }

  ListTile profilePageIconButton(BuildContext context) {
    return ListTile(
      title: Text(profileFavoriteTitle),
      leading: Icon(Icons.person),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
      },
    );
  }

  ListTile favoritePageIconButton(BuildContext context) {
    return ListTile(
      title: Text(drawerFavoriteTitle),
      leading: Icon(Icons.favorite),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FavoritePage()));
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
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LangingPage()),
              (Route<dynamic> route) => false);
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

  DrawerHeader buildDrawerHeader(BuildContext context) => DrawerHeader(
        child: Container(),
        duration: Duration(seconds: 1),
        decoration: buildDrawerHeaderBoxDecoration(context),
      );

  BoxDecoration buildDrawerHeaderBoxDecoration(BuildContext context) =>
      BoxDecoration(
        color: Theme.of(context).colorScheme.genelRenk,
        //borderRadius: BorderRadius.only(bottomRight: Radius.circular(30.0)),
        image: drawerImage(context),
        shape: BoxShape.circle,
      );

  DecorationImage drawerImage(BuildContext context) => DecorationImage(
        image: NetworkImage(Provider.of<UserViewModel>(context).user.userPhoto),
        fit: BoxFit.fill,
      );

  Column buildDrawerHeaderItem(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildNameAndMail(context),
        ],
      );

  ListTile buildNameAndMail(BuildContext context) => ListTile(
        title: buildDrawerHeaderItemTitle(context),
        subtitle: buildDrawerHeaderItemSubtitle(context),
      );

  Text buildDrawerHeaderItemSubtitle(BuildContext context) => Text(
        Provider.of<UserViewModel>(context).user.userEmail,
        style: Theme.of(context).textTheme.caption.copyWith(),
      );

  Text buildDrawerHeaderItemTitle(BuildContext context) {
    return Text(
      Provider.of<UserViewModel>(context).user.userName,
      style: Theme.of(context).textTheme.bodyText2,
    );
  }

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
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FolderDetailPage(
                      folderIndex: index,
                    )),
          );
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddingFolderPage()),
        );
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
