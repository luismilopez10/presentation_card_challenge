import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  late TextEditingController _nameController;
  late TextEditingController _professionController;
  late TextEditingController _documentController;

  final List<String> _documentTypes = ['ID', 'Foreign ID', 'Driver License'];
  String? _selectedDocumentType = 'ID';

  late String _strPath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "");
    _professionController = TextEditingController(text: "");
    _documentController = TextEditingController(text: "");
    _strPath = "";
  }

  bool validateAll() {
    if (formUserKey.currentState!.validate()) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all the fields")));
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
            //-----------------------------PICTURE------------------------------
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
                            image: _strPath != ""
                                ? DecorationImage(
                                    image: FileImage(File(_strPath)),
                                    fit: BoxFit.cover)
                                : result.hasData
                                    ? const DecorationImage(
                                        image: AssetImage(
                                            "assets/default-profile-picture.jpg"),
                                        fit: BoxFit.cover)
                                    : const DecorationImage(
                                        image: AssetImage(
                                            "assets/default-profile-picture.jpg"),
                                        fit: BoxFit.cover)),
                      );
                    }),
                //----------------------------CAMERA----------------------------
                Container(
                  margin: const EdgeInsets.only(left: 180.0),
                  child: IconButton(
                    icon: const Icon(MdiIcons.cameraPlus),
                    iconSize: 35,
                    onPressed: () async {
                      String? strImage =
                          await srvFiles.getImage(blnCamera: true);
                      setState(() {
                        _strPath = strImage!;
                      });
                    },
                  ),
                ),
                //---------------------------GALLERY----------------------------
                Container(
                  margin: const EdgeInsets.only(right: 180.0),
                  child: IconButton(
                    icon: const Icon(MdiIcons.imagePlus),
                    iconSize: 35,
                    onPressed: () async {
                      String? strImage = await srvFiles.getImage();
                      setState(() {
                        _strPath = strImage!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40.0,
            ),
            //----------------------------FULL NAME-----------------------------
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
            //------------------------PROFESSION OR ROLE------------------------
            TextFormField(
              minLines: 1,
              maxLines: 2,
              validator: (value) => validate(value!, "profession"),
              decoration: InputDecoration(
                hintText: 'Ex. Development consultant',
                labelText: 'Profession or Role',
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
                prefixIcon: Icon(Icons.cases_sharp),
              ),
              onChanged: (value) => () {},
              controller: _professionController,
            ),
            const SizedBox(height: 12.0),
            //--------------------------DOCUMENT TYPE---------------------------
            SizedBox(
              child: DropdownButtonFormField(
                validator: (value) =>
                    validate(_selectedDocumentType!, "identification-type"),
                decoration: InputDecoration(
                    labelText: 'Document Type',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.grey)),
                    prefixIcon: const Icon(Icons.account_box)),
                value: _selectedDocumentType,
                items: _documentTypes
                    .map((documentType) => DropdownMenuItem<String>(
                        value: documentType,
                        child: Text(
                          documentType,
                        )))
                    .toList(),
                onChanged: (documentType) => setState(
                    () => _selectedDocumentType = documentType as String?),
              ),
            ),
            const SizedBox(height: 12.0),
            //-----------------------------DOCUMENT-----------------------------
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
              ),
              onChanged: (value) => () {},
              controller: _documentController,
            ),
            const SizedBox(height: 30.0),
            //-----------------------------BUTTONS------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //-----------------------BUTTON "ERASE"-------------------------
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(155, 45)),
                  onPressed: () {
                    clearFormFields();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.backspace,
                        size: 18,
                        color: Colors.white,
                      ),
                      Text(
                        '  Clear',
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
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(155, 45)),
                  onPressed: () async {
                    File file = File(_strPath);
                    String imgConvert = base64Encode(file.readAsBytesSync());

                    srvSharedPreferences.writeString(
                        key: 'image', value: imgConvert);
                    srvSharedPreferences.writeString(
                        key: 'name', value: _nameController.text);
                    srvSharedPreferences.writeString(
                        key: 'profession', value: _professionController.text);
                    srvSharedPreferences.writeString(
                        key: 'identification-type',
                        value: _selectedDocumentType!);
                    srvSharedPreferences.writeString(
                        key: 'identification', value: _documentController.text);

                    if (validateAll()) {
                      await users
                          .add({
                            'picture_url': _strPath,
                            'full_name': _nameController.text,
                            'profession': _professionController.text,
                            'document_type': _selectedDocumentType,
                            'document': _documentController.text
                          })
                          .then((value) => {
                                clearFormFields(),
                                print("User Information Saved")
                              })
                          .catchError(
                              (error) => print("Failed to add user $error"));
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.save,
                        size: 23,
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

  void clearFormFields() {
    _strPath = "";
    _nameController.clear();
    _professionController.clear();
    _documentController.clear();
  }
}
