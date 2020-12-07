import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/custom_alert_dialog.dart';
import 'package:flutter_save_password/extensions/context_extension.dart';
import 'package:flutter_save_password/extensions/color_extension.dart';
import 'package:flutter_save_password/models/folder_model.dart';
import 'package:flutter_save_password/view_model/save_password_view_model.dart';
import 'package:provider/provider.dart';

class FolderSetingsPage extends StatefulWidget {
  final Folder folder;

  const FolderSetingsPage({Key key, this.folder}) : super(key: key);

  @override
  _FolderSetingsPageState createState() => _FolderSetingsPageState();
}

class _FolderSetingsPageState extends State<FolderSetingsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final buttonText = "Değişikliği kaydet";
  final labelText = "Dosya ismi";
  String newFolderName;
  List<Color> colorList = List();
  int selectedIndex;
  bool chance = false;

  @override
  void initState() {
    super.initState();
    newFolderName = widget.folder.folderName;
  }

  @override
  Widget build(BuildContext context) {
    findIndexFolderColor();

    return Scaffold(
      key: _scaffoldKey,
      appBar: context.appBar(
        widget.folder.folderName,
        leading: _appBarLeading,
        actions: appbarActions,
      ),
      body: _columnBody,
    );
  }

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
              _createButton,
            ],
          ),
        ),
      );

  Widget get _appBarLeading => IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: onWillPop,
      );

  Widget get _createButton => RaisedButton(
        color: Colors.deepOrange,
        onPressed: _saveButtonOnTap,
        child: _createButtonContainer,
      );

  Widget get _createButtonContainer => Container(
        width: context.width,
        alignment: Alignment.center,
        child: _createButtonContainerText,
      );

  Widget get _createButtonContainerText => Text(
        buttonText,
        style: context.theme.textTheme.subtitle1.copyWith(
          color: Colors.white,
        ),
      );

  Widget get _deleteIconButton => IconButton(
        icon: _deleteIcon,
        onPressed: () {
          final String deleteButtonText = "Kaydet";
          final String cancelButtonText = "Vazgeç";
          MyCustomDialog(
            title: Text("Silmek İstediğinize Emin misiniz ?"),
            content: Text(
                "Dosyayı silerseniz tüm hesaplarlar ile beraber silinecektir emin misiniz? "),
            actions: dialogChilderen(
              button1Txt: deleteButtonText,
              button2Txt: cancelButtonText,
              button1OnTap: deleteButtonOnTap,
              button2OnTap: cancelButtonOnTap,
            ),
          ).goster(context);
        },
      );

  Widget get _deleteIcon => Icon(Icons.delete, color: Colors.red[800]);

  void deleteButtonOnTap() async {
    bool result =
        await Provider.of<PasswordSaveViewModel>(context, listen: false)
            .deleteFolder(widget.folder);
    if (result) {
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(snackBar("Dosya silindi"));
    } else {
      Scaffold.of(context).showSnackBar(snackBar("Bir Hata oluştu"));
    }
  }

  Widget get _textField => TextFormField(
        maxLength: 10,
        initialValue: widget.folder.folderName,
        maxLengthEnforced: true,
        onChanged: (String txt) => chance = true,
        onSaved: (String txt) => newFolderName = txt,
        style: TextStyle(color: Colors.red),
        maxLines: 15,
        minLines: 1,
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

  void _saveButtonOnTap() {
    final String saveButtonText = "Kaydet";
    final String cancelButtonText = "Vazgeç";
    if (chance) {
      MyCustomDialog(
        content: Text("Değişikliği kaydetmek istediğinize emin misiniz"),
        actions: dialogChilderen(
          button1Txt: saveButtonText,
          button2Txt: cancelButtonText,
          button1OnTap: saveButtonOnTap,
          button2OnTap: cancelButtonOnTap,
        ),
      ).goster(context);
    }
  }

  saveButtonOnTap() {
    var newFolder = widget.folder;
    _formKey.currentState.save();
    if (newFolderName.length > 1 && newFolderName.length < 15) {
      newFolder.folderName = newFolderName;
      newFolder.folderColor = colorList[selectedIndex];
      Provider.of<PasswordSaveViewModel>(context, listen: false)
          .updateFolder(widget.folder, newFolder);
    }
  }

  cancelButtonOnTap() {
    Navigator.pop(context);
  }

  onWillPop(){
    if (chance) {
      MyCustomDialog(
        content: Text(
            "Değişikliği kaydetmediniz çıkmak istemediğinize emin misiniz"),
        actions: onWillPopButtonBar,
      ).goster(context);
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  List<Widget> dialogChilderen(
          {String button1Txt,
          String button2Txt,
          VoidCallback button1OnTap,
          VoidCallback button2OnTap}) =>
      [
        ButtonBar(
          children: [
            RaisedButton(
              child: Text(button1Txt),
              color: Theme.of(context).colorScheme.genelRenk,
              onPressed: button1OnTap,
            ),
            RaisedButton(
              child: Text(button2Txt),
              color: Theme.of(context).colorScheme.genelRenk,
              onPressed: button2OnTap,
            ),
          ],
        )
      ];

  Widget snackBar(txt) => SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Row(
          children: <Widget>[
            Icon(Icons.thumb_up),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(txt),
            ),
          ],
        ),
      );

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

  findIndexFolderColor() {
    if (!chance) {
      colorList = Theme.of(context).colorScheme.allFolderColor;
      for (int i = 0; i < colorList.length; i++) {
        if (colorList[i].value == widget.folder.folderColor.value) {
          selectedIndex = i;
        }
      }
      print(selectedIndex);
    }
  }
}
