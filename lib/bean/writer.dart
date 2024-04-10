class Writer {
  int writerid; //作者id
  String writername; //姓名
  String summary; //简介
  int dynastyid; //朝代
  int sex; //性别
  int birth; //出生年份
  int death; //去世年份
  int job; //职业

  Writer(this.writerid, this.writername, this.summary, this.dynastyid, this.sex,
      this.birth, this.death, this.job);

  // 用于从Map转换为Writer对象的工厂构造函数
  factory Writer.fromMap(Map<String, dynamic> map) {
    return Writer(map['writerid'], map['writername'], map['summary'],
        map['dynastyid'], map['sex'], map['birth'], map['death'], map['job']);
  }

  // 用于将User对象转换为Map的方法
  Map<String, dynamic> toMap() {
    return {
      "writerid": writerid,
      "writername": writername,
      "summary": summary,
      "dynastyid": dynastyid,
      "sex": sex,
      "birth": birth,
      "death": death,
      "job": job
    };
  }
}
