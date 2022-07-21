import 'package:flutter/material.dart';

import 'package:presentation_card_challenge/ui/widgets/WdgProfileForm.dart';

class PagProfile extends StatefulWidget {
  const PagProfile({Key? key}) : super(key: key);

  @override
  _PagProfileState createState() => _PagProfileState();
}

class _PagProfileState extends State<PagProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: formPageKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Personal card",
        ),
      ),
      body: const SingleChildScrollView(
        child: WdgProfileForm(),
      ),
    );
  }
}
