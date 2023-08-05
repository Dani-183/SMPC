import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModel {
  String? uid, name, logo, sportsId, collegeId;
  List? playersIds;
  bool? isDeleted;
  DateTime? createdAt;

  TeamModel({
    this.collegeId,
    this.createdAt,
    this.isDeleted,
    this.logo,
    this.name,
    this.playersIds,
    this.sportsId,
    this.uid,
  });

  TeamModel.fromFirestore(DocumentSnapshot doc) {
    collegeId = doc.get('collegeId');
    createdAt = (doc.get('createdAt') as Timestamp).toDate();
    isDeleted = doc.get('isDeleted');
    logo = doc.get('logo');
    name = doc.get('name');
    playersIds = doc.get('playersIds');
    sportsId = doc.get('sportsId');
    uid = doc.get('uid');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['collegeId'] = collegeId;
    data['createdAt'] = createdAt;
    data['isDeleted'] = isDeleted;
    data['logo'] = logo;
    data['name'] = name;
    data['playersIds'] = playersIds;
    data['sportsId'] = sportsId;
    data['uid'] = uid;
    return data;
  }

  Map<String, dynamic> toUpdateJson() {
    final data = <String, dynamic>{};
    collegeId == null ? null : data['collegeId'] = collegeId;
    isDeleted == null ? null : data['isDeleted'] = isDeleted;
    logo == null ? null : data['logo'] = logo;
    name == null ? null : data['name'] = name;
    sportsId == null ? null : data['sportsId'] = sportsId;
    uid == null ? null : data['uid'] = uid;
    return data;
  }
}
