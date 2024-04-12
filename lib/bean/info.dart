class Info {
  int infoid;
  int cateid;
  int fid;
  String title;
  String adder;
  String content;

  Info(
      this.infoid, this.cateid, this.fid, this.title, this.adder, this.content);

  factory Info.fromMap(Map<String, dynamic> map) {
    return Info(map['infoid'], map['cateid'], map['fid'], map['title'],
        map['adder'], map['content']);
  }
}
