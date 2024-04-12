class Poem {
  int poetryid;
  String typeid;
  int kindid;
  int dynastyid;
  int writerid;
  String writername;
  String title;
  String content;

  Poem(this.poetryid, this.typeid, this.kindid, this.dynastyid, this.writerid,
      this.writername, this.title, this.content);

  factory Poem.fromMap(Map<String, dynamic> map) {
    return Poem(map['poetryid'], map['typeid'], map['kindid'], map['dynastyid'],
        map['writerid'], map['writername'], map['title'], map['content']);
  }
}
