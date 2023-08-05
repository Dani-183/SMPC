import 'package:cloud_firestore/cloud_firestore.dart';

class SportsModel {
  String? uid, name, image, collegeId;
  bool? isDeleted;
  DateTime? createdAt;

  SportsModel({
    this.collegeId,
    this.createdAt,
    this.image,
    this.isDeleted,
    this.name,
    this.uid,
  });

  SportsModel.fromFirestore(DocumentSnapshot doc) {
    collegeId = doc.get('collegeId');
    createdAt = (doc.get('createdAt') as Timestamp).toDate();
    image = doc.get('image');
    isDeleted = doc.get('isDeleted');
    name = doc.get('name');
    uid = doc.get('uid');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['collegeId'] = collegeId;
    data['createdAt'] = createdAt;
    data['image'] = image;
    data['isDeleted'] = isDeleted;
    data['name'] = name;
    data['uid'] = uid;
    return data;
  }

  Map<String, dynamic> toUpdateJson() {
    final data = <String, dynamic>{};
    collegeId == null ? null : data['collegeId'] = collegeId;
    image == null ? null : data['image'] = image;
    isDeleted == null ? null : data['isDeleted'] = isDeleted;
    name == null ? null : data['name'] = name;
    return data;
  }
}
