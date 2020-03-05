import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Postjson {
  bool status;
  List<MainPaper> mainPaper;
  List<Papers> papers;

  Postjson({this.status, this.mainPaper, this.papers});

  Postjson.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['main_paper'] != null) {
      mainPaper = new List<MainPaper>();
      json['main_paper'].forEach((v) {
        mainPaper.add(new MainPaper.fromJson(v));
      });
    }
    if (json['papers'] != null) {
      papers = new List<Papers>();
      json['papers'].forEach((v) {
        papers.add(new Papers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.mainPaper != null) {
      data['main_paper'] = this.mainPaper.map((v) => v.toJson()).toList();
    }
    if (this.papers != null) {
      data['papers'] = this.papers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
@JsonSerializable()
class MainPaper {
  String type;
  String coverImage;
  String pdf;
  String districtName;


  MainPaper({this.type, this.coverImage, this.pdf, this.districtName,});

  MainPaper.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coverImage = json['cover_image'];
    pdf = json['pdf'];
    districtName = json['district_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['cover_image'] = this.coverImage;
    data['pdf'] = this.pdf;
    data['district_name'] = this.districtName;
    return data;
  }


}

@JsonSerializable()
class Papers {
  String type;
  String coverImage;
  String pdf;
  String districtName;
  String livetvurl;

  Papers({this.type, this.coverImage, this.pdf, this.districtName,this.livetvurl});

  Papers.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coverImage = json['cover_image'];
    pdf = json['pdf'];
    districtName = json['district_name'];
    livetvurl =json['livetv_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['cover_image'] = this.coverImage;
    data['pdf'] = this.pdf;
    data['district_name'] = this.districtName;
    data['livetv_url'] =this.livetvurl;
    return data;
  }
}