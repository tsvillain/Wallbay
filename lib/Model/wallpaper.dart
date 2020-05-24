class Wallpaper {
  String photographerName;
  String photographerUrl;
  String original;
  String portrait;

  Wallpaper({
    this.photographerName,
    this.photographerUrl,
    this.original,
    this.portrait,
  });

  Wallpaper.fromMap(Map<String, dynamic> map) {
    this.photographerName = map["photographer"];
    this.photographerUrl = map["photographer_url"];
    this.original = map["src"]["original"];
    this.portrait = map["src"]["portrait"];
  }

  toJson() {
    return {
      "photographer": this.photographerName,
      "photographer_url": this.photographerUrl,
      "original": this.original,
      "portrait": this.portrait,
    };
  }
}
