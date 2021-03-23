import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/custom_alert_dialog.dart';
import 'package:flutter_save_password/app/common__widget/custom_app_bar.dart';
import 'package:flutter_save_password/app/common__widget/custom_button.dart';
import 'package:flutter_save_password/app/helper/helper.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';
import 'package:flutter_save_password/init/navigation/navigation_constants.dart';
import 'package:flutter_save_password/init/navigation/navigation_services.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:provider/provider.dart';

class FolderSetingsPage extends StatefulWidget {
  final Folder? folder;

  const FolderSetingsPage({Key? key, this.folder}) : super(key: key);

  @override
  _FolderSetingsPageState createState() => _FolderSetingsPageState();
}

class _FolderSetingsPageState extends State<FolderSetingsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final buttonText = "Değişikliği kaydet";
  final labelText = "Dosya ismi";
  String? newFolderName;
  List<Color> colorList = [];
  int? selectedIndex;
  int maxLenght = 10;
  int minLenght = 1;
  bool chance = false;

  @override
  void initState() {
    super.initState();
    newFolderName = widget.folder!.folderName;
  }

  @override
  Widget build(BuildContext context) {
    findIndexFolderColor();

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar as PreferredSizeWidget?,
      body: _columnBody,
    );
  }

  Widget get appBar => CustomAppBar(
        widget.folder!.folderName,
        leading: _appBarLeading,
        actions: appbarActions,
      );

  List<Widget> get appbarActions {
    return [
      _deleteIconButton,
    ];
  }

  Widget get _columnBody => Container(
        padding: context.paddingAllLowMedium,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _textField,
              context.emptylowMediumValueWidget,
              _selectColorsWidget,
              context.emptylowMediumValueWidget,
              _saveButton,
            ],
          ),
        ),
      );

  Widget get _appBarLeading => IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: onWillPop,
      );

  Widget get _saveButton => MyCustomButton(
      buttonColor: Theme.of(context).colorScheme.genelRenk,
      onTap: _saveButtonOnPress,
      child: _createButtonContainerText,
    );


  Widget get _createButtonContainerText => Text(
        buttonText,
        style: context.theme.textTheme.subtitle1!.copyWith(
          color: Colors.white,
        ),
      );

  Widget get _deleteIconButton =>
      IconButton(icon: _deleteIcon, onPressed: deleteIconButtonOnPressed);

  Widget get _deleteIcon => Icon(Icons.delete, color: Colors.white);

  Widget get _textField => TextFormField(
        maxLength: maxLenght,
        initialValue: widget.folder!.folderName,
        onChanged: (String txt) => chance = true,
        onSaved: (String? txt) => newFolderName = txt,
        style: TextStyle(color: Colors.red),
        decoration: context.customInputDecoration(
          labelText,
          color: context.theme.colorScheme.genelRenk,
        ),
      );

  Widget get _selectColorsWidget => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: Theme.of(context)
          .colorScheme
          .allFolderColor
          .asMap()
          .map((key, value) => MapEntry(
              key,
              InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = key;
                    chance = true;
                  });
                },
                child: Padding(
                  padding: context.paddingAllLowValue,
                  child: CircleAvatar(
                    child:
                        key == selectedIndex ? Icon(Icons.check) : Container(),
                    backgroundColor: value,
                  ),
                ),
              )))
          .values
          .toList());

  void _saveButtonOnPress() {
    if (chance) {
      saveButtonOnTap();
    }
  }

  onWillPop() {
    if (chance) {
      MyCustomDialog(
        content: Text(
            "Değişikliği kaydetmediniz çıkmak istemediğinize emin misiniz"),
        actions: onWillPopButtonBar,
      ).goster(context);
    } else {
      Navigator.pop(context);
    }
  }

  List<Widget> dialogChilderen({
    String? button1Txt,
    String? button2Txt,
    VoidCallback? button1OnTap,
    VoidCallback? button2OnTap,
  }) =>
      [
        ButtonBar(
          children: [
            MyCustomButton(
              onTap: button2OnTap,
              buttonText: button2Txt,
              buttonColor: Theme.of(context).colorScheme.genelRenk,
            ),
            MyCustomButton(
              onTap: button1OnTap,
              buttonText: button1Txt,
              buttonColor: Theme.of(context).colorScheme.genelRenk,
            ),
          ],
        )
      ];

  List<Widget> get onWillPopButtonBar {
    final String comeBackButtonText = "Çık";
    final String cancelButtonText = "Vazgeç";
    return [
      ButtonBar(
        children: dialogChilderen(
            button1Txt: cancelButtonText,
            button2Txt: comeBackButtonText,
            button1OnTap: cancelButtonOnTap,
            button2OnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }),
      ),
    ];
  }

  deleteIconButtonOnPressed() {
    final String deleteButtonText = "Sil";
    final String cancelButtonText = "Vazgeç";
    MyCustomDialog(
      title: Text("Silmek İstediğinize Emin misiniz ?"),
      content: Text(
          "Dosyayı silerseniz tüm hesaplarlar ile beraber silinecektir emin misiniz? "),
      actions: dialogChilderen(
        button2Txt: deleteButtonText,
        button1Txt: cancelButtonText,
        button2OnTap: deleteButtonOnTap,
        button1OnTap: cancelButtonOnTap,
      ),
    ).goster(context);
  }

  void deleteButtonOnTap() async {
    bool result =
        await Provider.of<PasswordSaveViewModel>(context, listen: false)
            .deleteFolder(widget.folder);
    result
        ? NavigationServices.instance
            .navigateToPageClear(path: NavigationConstans.HOME_PAGE)
        : Helper.showDefaultSnackBar(context, "Bir hata oluştu");
  }

  saveButtonOnTap() async {
    var newFolder = widget.folder;
    _formKey.currentState!.save();
    bool? result = false;
    if (newFolderName!.length > minLenght && newFolderName!.length < maxLenght) {
      newFolder!.folderName = newFolderName;
      newFolder.folderColor = colorList[selectedIndex!];
      result = await (Provider.of<PasswordSaveViewModel>(context, listen: false)
          .updateFolder(widget.folder!, newFolder) as FutureOr<bool>);
    }
    if (result) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  cancelButtonOnTap() {
    Navigator.pop(context);
  }

  findIndexFolderColor() {
    if (!chance) {
      colorList = Theme.of(context).colorScheme.allFolderColor;
      for (int i = 0; i < colorList.length; i++) {
        if (colorList[i].value == widget.folder!.folderColor!.value) {
          selectedIndex = i;
        }
      }
      print(selectedIndex);
    }
  }
}
