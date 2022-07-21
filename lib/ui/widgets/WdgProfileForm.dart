import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:presentation_card_challenge/services/srvSharedPreferences.dart';
import 'package:presentation_card_challenge/services/srvFiles.dart';

GlobalKey<FormState> formUserKey = GlobalKey<FormState>();
GlobalKey<ScaffoldState> formPageKey = GlobalKey<ScaffoldState>();

class WdgProfileForm extends StatefulWidget {
  const WdgProfileForm({Key? key}) : super(key: key);

  @override
  State<WdgProfileForm> createState() => _WdgProfileFormState();
}

class _WdgProfileFormState extends State<WdgProfileForm> {
  late TextEditingController _nameController;
  late TextEditingController _professionController;
  late TextEditingController _documentController;

  List<String> documentTypes = ['ID', 'Foreign ID'];
  String? selectedDocumentType = 'ID';

  late String strPath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "");
    _professionController = TextEditingController(text: "");
    _documentController = TextEditingController(text: "");
    strPath = "";
  }

  bool validateAll() {
    if (formUserKey.currentState!.validate()) {
      return true;
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill all the fields")));
      return false;
    }
  }

  String? validate(String value, String key) =>
      value.isEmpty ? "Please fill the $key field" : null;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formUserKey,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            //-------------------------PROFILE PICTURE--------------------------
            //------------------------------FOTO--------------------------------
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                FutureBuilder(
                    future: srvSharedPreferences.readString(key: 'image'),
                    builder: (context, result) {
                      return Container(
                        height: 150.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100.0),
                            border: Border.all(color: Colors.grey, width: 1.5),
                            image: strPath != ""
                                ? DecorationImage(
                                    image: FileImage(File(strPath)),
                                    fit: BoxFit.cover)
                                : const DecorationImage(
                                    image: AssetImage(
                                        "assets/default-profile-picture.jpg"),
                                    fit: BoxFit.cover)),
                      );
                    }),
                //--------------------------CÁMARA--------------------------
                Container(
                  margin: const EdgeInsets.only(left: 180.0),
                  child: IconButton(
                    icon: const Icon(MdiIcons.cameraPlus),
                    iconSize: 35,
                    onPressed: () async {
                      String? strImage =
                          await srvFiles.getImage(blnCamera: true);
                      setState(() {
                        strPath = strImage!;
                      });
                    },
                  ),
                ),
                //-------------------------GALERÍA--------------------------
                Container(
                  margin: const EdgeInsets.only(right: 180.0),
                  child: IconButton(
                    icon: const Icon(MdiIcons.imagePlus),
                    iconSize: 35,
                    onPressed: () async {
                      String? strImage = await srvFiles.getImage();
                      setState(() {
                        strPath = strImage!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40.0,
            ),
            //-------------------------FULL NAME--------------------------
            TextFormField(
              minLines: 1,
              maxLines: 2,
              keyboardType: TextInputType.name,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[A-Z a-z]"))
              ],
              validator: (value) => validate(value!, "name"),
              decoration: InputDecoration(
                hintText: 'Ex. Luis Miguel López',
                labelText: 'Full Name',
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: (value) => () {},
              controller: _nameController,
            ),
            const SizedBox(height: 12.0),
            //---------------------PROFESSION OR ROLE---------------------
            TextFormField(
              minLines: 1,
              maxLines: 2,
              validator: (value) => validate(value!, "profession"),
              decoration: InputDecoration(
                hintText: 'Ex. Development consultant',
                labelText: 'Profession or role',
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
                prefixIcon: Icon(Icons.cases_sharp),
              ),
              onChanged: (value) => () {},
              controller: _professionController,
            ),
            const SizedBox(height: 12.0),
            //-----------------------DOCUMENT TYPE------------------------
            SizedBox(
              child: DropdownButtonFormField(
                validator: (value) =>
                    validate(selectedDocumentType!, "identification-type"),
                decoration: InputDecoration(
                    labelText: 'Document Type',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(width: 2, color: Colors.blue)),
                    prefixIcon: Icon(Icons.account_box)),
                value: selectedDocumentType,
                items: documentTypes
                    .map((documentType) => DropdownMenuItem<String>(
                        value: documentType,
                        child: Text(
                          documentType,
                        )))
                    .toList(),
                onChanged: (documentType) => setState(
                    () => selectedDocumentType = documentType as String?),
              ),
            ),
            const SizedBox(height: 12.0),
            //--------------------------DOCUMENT--------------------------
            TextFormField(
              keyboardType: TextInputType.number,
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
              ],
              validator: (value) => validate(value!, "identification"),
              decoration: InputDecoration(
                hintText: 'Ex. 1234567890',
                labelText: 'Identification Number',
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
                prefixIcon: const Icon(Icons.badge_rounded),
                // prefixIcon: const Icon(Icons.account_box),
              ),
              onChanged: (value) => () {},
              controller: _documentController,
            ),
            const SizedBox(height: 12.0),
            //-----------------------------BUTTONS------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //-----------------------BUTTON "ERASE"-------------------------
                ElevatedButton(
                  onPressed: () {
                    _nameController.clear();
                    _professionController.clear();
                    _documentController.clear();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        height: 55,
                      ),
                      Icon(
                        Icons.backspace,
                        size: 25,
                        color: Colors.white,
                      ),
                      Text(
                        '  Erase',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                //-----------------------BUTTON "SAVE"--------------------------
                ElevatedButton(
                  onPressed: () {
                    File file = File(strPath);
                    String imgConvert = base64Encode(file.readAsBytesSync());

                    srvSharedPreferences.writeString(
                        key: 'name', value: _nameController.text);
                    srvSharedPreferences.writeString(
                        key: 'profession', value: _professionController.text);
                    // srvSharedPreferences.writeString(
                    //     key: 'identification-type',
                    //     value: _documentTypeController.text);
                    srvSharedPreferences.writeString(
                        key: 'identification', value: _documentController.text);
                    srvSharedPreferences.writeString(
                        key: 'image', value: imgConvert);

                    if (validateAll()) {
                      print("Information saved");
                      //TODO: Change user values
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        height: 55,
                      ),
                      Icon(
                        Icons.save,
                        size: 35,
                        color: Colors.white,
                      ),
                      Text(
                        ' Save',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _documentController.dispose();
    super.dispose();
  }
}
