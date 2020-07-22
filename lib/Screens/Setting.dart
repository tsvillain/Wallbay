import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallbay/const.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String _packageName;
  String _version;
  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _packageName = packageInfo.packageName;
      _version = packageInfo.version;
    });
    super.initState();
  }

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
                "$message\n${url + _packageName}",
              );
            },
          ),
          ListTile(
            title: Text("Source Code"),
            subtitle: Text("Find Source Code on GitHub."),
            onTap: () => launch("$gitHubUrl"),
          ),
          ListTile(
            title: Text("Rate App"),
            subtitle: Text("Leave a review on the Google Play Store."),
            onTap: () => launch(url + _packageName),
          ),
          ListTile(
            title: Text("App Version"),
            subtitle: Text("${_version ?? "1.0.0"} "),
          )
        ],
      ),
    );
  }
}
