import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share/share.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text("Recommend"),
            subtitle: Text("Share this app with your friends and family."),
            onTap: () {
              Share.share(
                  "https://play.google.com/store/apps/details?id=app.tsvillain.wallbay \nHey! Check this app out.");
            },
          ),
          ListTile(
            title: Text("Rate App"),
            subtitle: Text("Leave a review on the Google Play Store."),
            onTap: LaunchReview.launch,
          ),
          ListTile(
            title: Text("App Version"),
            subtitle: Text("1.0.0"),
          )
        ],
      ),
    );
  }
}
