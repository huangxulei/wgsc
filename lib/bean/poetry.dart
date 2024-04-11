class Poetry {
  int poetryid;
  String typeid;
  int kindid;
  int writerid;
  String title;
  String content;

  Poetry(this.poetryid, this.typeid, this.kindid, this.writerid, this.title,
      this.content);

  factory Poetry.fromMap(Map<String, dynamic> map) {
    return Poetry(map['poetryid'], map['typeid'], map['kindid'],
        map['writerid'], map['title'], map['content']);
  }
}
