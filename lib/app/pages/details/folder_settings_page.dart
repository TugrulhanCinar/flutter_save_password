import 'package:flutter/material.dart';
import 'package:flutter_save_password/app/common__widget/custom_alert_dialog.dart';
import 'package:flutter_save_password/app/common__widget/custom_app_bar.dart';
import 'package:flutter_save_password/app/pages/home_page.dart';
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
  int maxLenght = 10;
  int minLenght = 1;
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
      appBar: appBar,
      body: _columnBody,
    );
  }

  Widget get appBar => CustomAppBar(
        widget.folder.folderName,
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

  Widget get _saveButton => RaisedButton(
        color: Colors.deepOrange,
        onPressed: _saveButtonOnPress,
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

  Widget get _deleteIconButton =>
      IconButton(icon: _deleteIcon, onPressed: deleteIconButtonOnPressed);

  Widget get _deleteIcon => Icon(Icons.delete, color: Colors.red[800]);

  Widget get _textField => TextFormField(
        maxLength: maxLenght,
        initialValue: widget.folder.folderName,
        maxLengthEnforced: true,
        onChanged: (String txt) => chance = true,
        onSaved: (String txt) => newFolderName = txt,
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
    final String saveButtonText = "Kaydet";
    final String cancelButtonText = "Vazgeç";
    if (chance) {
      MyCustomDialog(
        content: Text("Değişikliği kaydetmek istediğinize emin misiniz"),
        actions: dialogChilderen(
          button1Txt: cancelButtonText,
          button2Txt: saveButtonText,
          button1OnTap: cancelButtonOnTap,
          button2OnTap: saveButtonOnTap,
        ),
      ).goster(context);
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

    return Future.value(false);
  }

  List<Widget> dialogChilderen({
    String button1Txt,
    String button2Txt,
    VoidCallback button1OnTap,
    VoidCallback button2OnTap,
  }) =>
      [
        ButtonBar(
          children: [
            RaisedButton(
              child: Text(button2Txt),
              color: Theme.of(context).colorScheme.genelRenk,
              onPressed: button2OnTap,
            ),
            RaisedButton(
              child: Text(button1Txt),
              color: Theme.of(context).colorScheme.genelRenk,
              onPressed: button1OnTap,
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
    if (result) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false);
    } else {
      _scaffoldKey.currentState.showSnackBar(snackBar("Bir hata oluştu"));
      print("bir hata oluştu deleteButtonOnTap");
    }
  }


  saveButtonOnTap() async{
    var newFolder = widget.folder;
    _formKey.currentState.save();
    bool result = false;
    if (newFolderName.length > minLenght && newFolderName.length < maxLenght) {
      newFolder.folderName = newFolderName;
      newFolder.folderColor = colorList[selectedIndex];
      result =  await Provider.of<PasswordSaveViewModel>(context, listen: false)
          .updateFolder(widget.folder, newFolder);

    }
    if(result){
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
        if (colorList[i].value == widget.folder.folderColor.value) {
          selectedIndex = i;
        }
      }
      print(selectedIndex);
    }
  }
}
