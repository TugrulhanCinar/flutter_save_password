import 'package:flutter/material.dart';
import 'file:///E:/flutterProject/flutter_save_password/lib/app/pages/details/account_details_page.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';
import 'custom_alert_dialog.dart';

// ignore: must_be_immutable
class AccountModelWidget extends StatelessWidget {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String alertDialogTitle = "Sil";

  final String alertDialogContent =
      "Hesabı silmek istediğinize emin misiniz ? ";
  final Account account;
  final String customTitle;
  final int folderIndex;
  final int accountIndex;
  Account _account;

  AccountModelWidget({
    Key key,
    this.customTitle,
    this.folderIndex,
    this.accountIndex,
    this.account,
  })  : assert(account == null || accountIndex == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (account == null) {
      _account = Provider.of<PasswordSaveViewModel>(context)
          .folders[folderIndex]
          .accounts[accountIndex];
    } else {
      _account = account;
    }
    return buildPasswordListItem(context);
  }

  ListTile buildPasswordListItem(BuildContext context) => ListTile(
        title: _listTileTitle,
        subtitle: _listTileSubTitle,
        leading: favoriteIconButton(context),
        trailing: _listTileTrailingIcon(context),
        onTap: () => listTileOnTap(context),
      );

  listTileOnTap(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountDetailPage(
          account: _account,
        ),
      ),
    );
  }

  Widget favoriteIconButton(BuildContext context) {
    bool favorite = _account.favorite;
    return IconButton(
      icon: favorite
          ? Icon(
              Icons.star,
              color: Colors.yellow,
            )
          : Icon(Icons.star_border),
      onPressed: () {
        Provider.of<PasswordSaveViewModel>(context, listen: false)
            .updateFavoriteState(_account);
      },
    );
  }

  Widget get _listTileTitle => Text(_account.accountName);

  Widget get _listTileSubTitle => Text(
        customTitle == null
            ? formatter.format(_account.accountCreateTime)
            : customTitle,
      );

  Widget favoriteIconButon(BuildContext context) => IconButton(
        icon: favoriteIcon,
        onPressed: favoriteIconButonOnTap(context),
      );

  Widget _listTileTrailingIcon(BuildContext context) => IconButton(
        icon: _deleteIcon,
        onPressed: () {
          MyCustomDialog(
            title: Text(alertDialogTitle),
            actions: dialogChilderen(_account, context),
            content: Text(alertDialogContent),
          ).goster(context);
        },
      );

  Widget get _deleteIcon => Icon(Icons.delete, color: Colors.red[800]);

  favoriteIconButonOnTap(BuildContext context) {
    Provider.of<PasswordSaveViewModel>(context, listen: false)
        .updateFavoriteState(account);
    _account.favorite = !_account.favorite;
  }

  Widget get favoriteIcon => Icon(
        Icons.star,
        size: 36,
        color: _account.favorite ? Colors.yellow : null,
      );

  List<Widget> dialogChilderen(Account account, BuildContext context) => [
        ButtonBar(
          children: [
            RaisedButton(
              child: Text("Vazgeç"),
              color: Theme.of(context).colorScheme.genelRenk,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            RaisedButton(
              child: Text("Sil"),
              color: Theme.of(context).colorScheme.genelRenk,
              onPressed: () {
                final _savePass =
                    Provider.of<PasswordSaveViewModel>(context, listen: false);
                _savePass.deleteAccount(account);
                Navigator.pop(context);
              },
            ),
          ],
        )
      ];
}
