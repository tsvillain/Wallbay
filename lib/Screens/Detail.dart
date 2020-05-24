import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallbay/Model/wallpaper.dart';
import 'package:wallpaperplugin/wallpaperplugin.dart';
import 'package:flutter/services.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';

class Detail extends StatefulWidget {
  final Wallpaper wallpaper;

  Detail({@required this.wallpaper});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool permission = false;
  bool downloadImage = false;
  String downPer = "0%";
  final String nAvail = "Not Available";

  _permissionRequest() async {
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'Wallbay',
    );
    var result = await permissionValidator.storage();
    if (result) {
      setState(() {
        permission = true;
        setWallpaper();
      });
    }
  }

  void _launchURL(BuildContext context, url) async {
    try {
      await launch(
        url,
        option: CustomTabsOption(
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsAnimation.slideIn(),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          child: PhotoView(
            imageProvider: NetworkImage(widget.wallpaper.portrait),
            minScale: PhotoViewComputedScale.covered * 1.0,
            maxScale: PhotoViewComputedScale.covered * 1.0,
          ),
        ),
        Positioned(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Card(
            margin: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/lego/1.jpg"),
              ),
              title: Text(widget.wallpaper.photographerName),
              subtitle: GestureDetector(
                  onTap: () {
                    _launchURL(context, widget.wallpaper.photographerUrl);
                  },
                  child: Text("by Pexels")),
              trailing: downloadImage
                  ? CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Text(
                        downPer,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : IconButton(
                      splashColor: Colors.black45,
                      icon: Icon(Icons.wallpaper),
                      onPressed: () {
                        if (permission == false) {
                          print("Requesting Permission");
                          _permissionRequest();
                        } else {
                          print("Permission Granted.");
                          setWallpaper();
                        }
                      },
                    ),
            ),
          ),
        ),
      ]),
    );
  }

  void setWallpaper() async {
    final dir = await getExternalStorageDirectory();
    print(dir);
    Dio dio = new Dio();
    dio.download(
      widget.wallpaper.original,
      "${dir.path}/wallbay.png",
      onReceiveProgress: (received, total) {
        if (total != -1) {
          String downloadingPer =
              ((received / total * 100).toStringAsFixed(0) + "%");
          setState(() {
            downPer = downloadingPer;
          });
        }
        setState(() {
          downloadImage = true;
        });
      },
    ).whenComplete(() {
      setState(() {
        downloadImage = false;
      });
      initPlatformState("${dir.path}/wallbay.png");
    });
  }

  Future<void> initPlatformState(String path) async {
    String wallpaperStatus = "Unexpected Result";
    String _localFile = path;
    try {
      Wallpaperplugin.setWallpaperWithCrop(localFile: _localFile);
      wallpaperStatus = "new Wallpaper set";
    } on PlatformException {
      print("Platform exception");
      wallpaperStatus = "Platform Error Occured";
    }
    if (!mounted) return;
  }
}
