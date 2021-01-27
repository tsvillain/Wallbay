import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallbay/Model/wallpaper.dart';
import 'package:flutter/services.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Hero(
          tag: widget.wallpaper.portrait,
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: Image.network(
                widget.wallpaper.portrait,
                fit: BoxFit.cover,
              )),
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
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: downloadImage
                ? Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        "Downloading.. $downPer",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      if (permission == false) {
                        print("Requesting Permission");
                        _permissionRequest();
                      } else {
                        print("Permission Granted.");
                        setWallpaper();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          "Set Wallpaper",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
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
      showModalBottomSheet(
          isDismissible: false,
          context: context,
          builder: (_) {
            return Container(
              margin: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GFButton(
                    onPressed: () {
                      initPlatformState("${dir.path}/wallbay.png",
                          WallpaperManager.HOME_SCREEN);
                      Navigator.pop(context);
                    },
                    text: "HomeScreen",
                  ),
                  GFButton(
                    onPressed: () {
                      initPlatformState("${dir.path}/wallbay.png",
                          WallpaperManager.LOCK_SCREEN);
                      Navigator.pop(context);
                    },
                    text: "LockScreen",
                  ),
                  GFButton(
                    onPressed: () {
                      initPlatformState("${dir.path}/wallbay.png",
                          WallpaperManager.BOTH_SCREENS);
                      Navigator.pop(context);
                    },
                    text: "Both",
                  ),
                ],
              ),
            );
          });
    });
  }

  Future<void> initPlatformState(String path, int location) async {
    try {
      await WallpaperManager.setWallpaperFromFile(path, location);
      Fluttertoast.showToast(
          msg: 'Wallpaper Applied.', toastLength: Toast.LENGTH_SHORT);
    } on PlatformException {
      Fluttertoast.showToast(
          msg: 'Please Try Again Later.', toastLength: Toast.LENGTH_SHORT);
      print("Platform exception");
    }
    if (!mounted) return;
  }
}
