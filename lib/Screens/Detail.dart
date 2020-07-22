import 'package:flutter/material.dart';
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
                  // GFButton(
                  //     onPressed: () {},
                  //     text: "Downloading... $downPer",
                  //     shape: GFButtonShape.pills,
                  //     color: Colors.white54,
                  //   )
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
                    )
              // GFButton(
              //     onPressed: () {
              //       if (permission == false) {
              //         print("Requesting Permission");
              //         _permissionRequest();
              //       } else {
              //         print("Permission Granted.");
              //         setWallpaper();
              //       }
              //     },
              //     text: "Set Wallpaper",
              //     shape: GFButtonShape.pills,
              //     color: Colors.white54,
              //   ),
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
      wallpaperStatus = "Wallpaper set";
    } on PlatformException {
      print("Platform exception");
      wallpaperStatus = "Platform Error Occured";
    }
    if (!mounted) return;
  }
}
