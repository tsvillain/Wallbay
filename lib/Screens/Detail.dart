import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaperplugin/wallpaperplugin.dart';
import 'package:flutter/services.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';

class Detail extends StatefulWidget {
  final String userName,
      userImg,
      subtitle,
      largeImage,
      portfolio,
      bio,
      location,
      link,
      rawImage;

  Detail(this.userName, this.userImg, this.subtitle, this.largeImage,
      this.portfolio, this.bio, this.location, this.link, this.rawImage);

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

  void _onBtnPressed() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        builder: (context) {
          return Container(
            child: _bottomMenu(),
          );
        });
  }

  Column _bottomMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 3),
          child: CircleAvatar(
            radius: 50.0,
            backgroundImage: NetworkImage(widget.userImg),
            backgroundColor: Colors.transparent,
          ),
        ),
        ListTile(
          title: Text(
            widget.userName,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: widget.bio == null
              ? Text(nAvail)
              : Text(
                  widget.bio,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
        ),
        ListTile(
          leading: Icon(Icons.web_asset),
          title:
              widget.portfolio == null ? Text(nAvail) : Text(widget.portfolio),
          onTap: () {
            widget.portfolio == null
                ? print("Not Available")
                : _launchURL(context, widget.portfolio);
          },
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: widget.location == null ? Text(nAvail) : Text(widget.location),
        ),
        ListTile(
          leading: Icon(Icons.ac_unit),
          title: widget.link == null ? Text(nAvail) : Text(widget.link),
          subtitle: Text('Unsplash Account'),
          onTap: () {
            widget.link == null
                ? print("Not Available")
                : _launchURL(context, widget.link+"?utm_source=Wallbay&utm_medium=referral");
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (dragUpdateDetails) {
          _onBtnPressed();
        },
        child: Stack(children: <Widget>[
          Container(
            child: PhotoView(
              imageProvider: NetworkImage(widget.largeImage),
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
                onTap: () {
                  _onBtnPressed();
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(widget.userImg),
                ),
                title: Text(widget.userName),
                subtitle: Text(widget.subtitle),
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
      ),
    );
  }

  void setWallpaper() async {
    final dir = await getExternalStorageDirectory();
    print(dir);
    Dio dio = new Dio();
    dio.download(
      widget.rawImage,
      "${dir.path}/newall.png",
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
      initPlatformState("${dir.path}/newall.png");
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
