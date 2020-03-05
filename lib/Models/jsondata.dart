import 'package:json_annotation/json_annotation.dart';



@JsonSerializable()
class Jsondata{
  bool status;
  bool Adds;
  List<CategorisedList> categorisedList;
  String scroll_text;

  Jsondata({this.status, this.categorisedList,this.scroll_text});

  Jsondata.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['categorisedList'] != null) {
      categorisedList = new List<CategorisedList>();
      json['categorisedList'].forEach((v) {
        categorisedList.add(new CategorisedList.fromJson(v));
      });
    }
    scroll_text = json['scroll_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.categorisedList != null) {
      data['categorisedList'] =
          this.categorisedList.map((v) => v.toJson()).toList();
    }
    data['scroll_text'] = this.scroll_text;
   
  }
}
@JsonSerializable()
class CategorisedList {
  String categoryId;
  String categoryName;
  String categoryImage;
  List<SubCategories> subCategories;

  CategorisedList(
      {this.categoryId,
      this.categoryName,
      this.categoryImage,
      this.subCategories});

  CategorisedList.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    categoryImage = json['categoryImage'];
    if (json['sub_categories'] != null) {
      subCategories = new List<SubCategories>();
      json['sub_categories'].forEach((v) {
        subCategories.add(new SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['categoryImage'] = this.categoryImage;
    if (this.subCategories != null) {
      data['sub_categories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
@JsonSerializable()
class SubCategories {
  String id;
  String categoryName;
  String subCatName;
  String shortDesc;
  String link;
  String image;
  String status;
  String createdDate;
  String updatedDate;
  String deleted;

  SubCategories(
      {this.id,
      this.categoryName,
      this.subCatName,
      this.shortDesc,
      this.link,
      this.image,
      this.status,
      this.createdDate,
      this.updatedDate,
      this.deleted});

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    subCatName = json['sub_cat_name'];
    shortDesc = json['short_desc'];
    link = json['link'];
    image = json['image'];
    status = json['status'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['sub_cat_name'] = this.subCatName;
    data['short_desc'] = this.shortDesc;
    data['link'] = this.link;
    data['image'] = this.image;
    data['status'] = this.status;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['deleted'] = this.deleted;
    return data;
  }
}
