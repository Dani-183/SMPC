import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerModel {
  String? rollNo, name, phoneNo, image, collegeId, uid;
  bool? isDeleted;
  DateTime? addedAt;

  PlayerModel({
    this.uid,
    this.collegeId,
    this.addedAt,
    this.image,
    this.isDeleted,
    this.name,
    this.phoneNo,
    this.rollNo,
  });

  PlayerModel.fromFirestore(DocumentSnapshot doc) {
    addedAt = (doc.get('addedAt') as Timestamp).toDate();
    image = doc.get('image');
    uid = doc.get('uid');
    collegeId = doc.get('collegeId');
    isDeleted = doc.get('isDeleted');
    name = doc.get('name');
    phoneNo = doc.get('phoneNo');
    rollNo = doc.get('rollNo');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['addedAt'] = addedAt;
    data['image'] = image;
    data['uid'] = uid;
    data['collegeId'] = collegeId;
    data['isDeleted'] = isDeleted;
    data['name'] = name;
    data['phoneNo'] = phoneNo;
    data['rollNo'] = rollNo;
    return data;
  }

  Map<String, dynamic> toUpdateJson() {
    final data = <String, dynamic>{};
    image == null ? null : data['image'] = image;
    name == null ? null : data['name'] = name;
    phoneNo == null ? null : data['phoneNo'] = phoneNo;
    rollNo == null ? null : data['rollNo'] = rollNo;
    return data;
  }
}
