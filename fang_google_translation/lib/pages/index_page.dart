import 'package:flutter/material.dart';
import '../pages/drawer_page.dart';
import '../pages/body_page.dart';
import '../pages/textfield_page.dart';
import '../pages/recording_page.dart';

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Google Translate'),
          elevation: 0.0,
        ),
        drawer: DrawerPage(),
        body: Column(
          children: <Widget>[
            IndexBody(),
            TextFieldPage(),
            Container(
              height: 10,
            ),
            RecordingT(),
          ],
        ),
      ),
    );
  }
}
