class Wallpaper {
  String original;
  String portrait;

  Wallpaper({
    this.original,
    this.portrait,
  });

  Wallpaper.fromMap(Map<String, dynamic> map) {
    this.original = map["src"]["original"];
    this.portrait = map["src"]["portrait"];
  }

  toJson() {
    return {
      "original": this.original,
      "portrait": this.portrait,
    };
  }
}
