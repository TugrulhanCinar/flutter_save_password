import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/pages/password_page.dart';
import 'package:flutter_save_password/models/account_model.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'custom_alert_dialog.dart';

class AccountModelWidget extends StatelessWidget {
  final BuildContext context;
  final Account account;
  final String customTitle;
  final String alertDialogTitle = "Sil";

  final String alertDialogContent =
      "Hesabı silmek istediğinize emin misiniz ? ";
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  AccountModelWidget({
    Key key,
    this.account,
    this.context,
    this.customTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildPasswordItem;
  }

  Container get buildPasswordItem => Container(
        decoration: context.boxDecoration,
        margin: context.paddingAllLowMedium,
        child: buildPasswordListItem,
      );

  ListTile get buildPasswordListItem => ListTile(
        title: _listTileTitle,
        subtitle: _listTileSubTitle,
        leading: _listTileLeadingIcon,
        trailing: _listTileTrailingIcon,
       // onTap: listTileOntap,
      );

  Widget get _listTileTitle => Text(account.accountName);

  Widget get _listTileSubTitle => Text(
        customTitle == null
            ? formatter.format(account.accountCreateTime)
            : customTitle,
      );

  listTileOntap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordPage(
          account: account,
        ),
      ),
    );
  }

  Widget get _listTileTrailingIcon => IconButton(
        icon: _deleteIcon,
        onPressed: () {
          MyCustomDialog(
            title: Text(alertDialogTitle),
            actions: dialogChilderen(account),
            content: Text(alertDialogContent),
          ).goster(context);
        },
      );

  Widget get _deleteIcon => Icon(Icons.delete, color: Colors.red[800]);

  Container get _listTileLeadingIcon => Container(
        height: double.infinity,
        child: favoriteIconButon,
      );

  Widget get favoriteIconButon => IconButton(
        icon: favoriteIcon,
        onPressed: favoriteIconButonOnTap,
      );

  favoriteIconButonOnTap() {
    final _savePass =
        Provider.of<PasswordSaveViewModel>(context, listen: false);
    _savePass.updateFavoriteState(account);
  }

  Widget get favoriteIcon => Icon(
        Icons.star,
        size: 36,
        color: account.favorite ? Colors.yellow : null,
      );

  List<Widget> dialogChilderen(Account account) => [
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
