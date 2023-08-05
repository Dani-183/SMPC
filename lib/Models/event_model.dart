import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? uid, title, description, image, winnerTeamId, runnerTeamId, terms, winningPrize, location, createdBy;
  DateTime? createdAt, lastDateToJoin, endDate;
  num? entryFee;
  bool? isDeleted;
  List? joinedList;

  EventModel({
    this.createdAt,
    this.createdBy,
    this.description,
    this.endDate,
    this.entryFee,
    this.image,
    this.isDeleted,
    this.joinedList,
    this.lastDateToJoin,
    this.location,
    this.runnerTeamId,
    this.terms,
    this.title,
    this.uid,
    this.winnerTeamId,
    this.winningPrize,
  });

  EventModel.fromFirestore(DocumentSnapshot doc) {
    createdAt = (doc.get('createdAt') as Timestamp).toDate();
    createdBy = doc.get('createdBy');
    description = doc.get('description');
    endDate = (doc.get('endDate') as Timestamp).toDate();
    entryFee = doc.get('entryFee');
    image = doc.get('image');
    isDeleted = doc.get('isDeleted');
    joinedList = doc.get('joinedList');
    lastDateToJoin = (doc.get('lastDateToJoin') as Timestamp).toDate();
    location = doc.get('location');
    runnerTeamId = doc.get('runnerTeamId');
    terms = doc.get('terms');
    title = doc.get('title');
    uid = doc.get('uid');
    winnerTeamId = doc.get('winnerTeamId');
    winningPrize = doc.get('winningPrize');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    data['description'] = description;
    data['endDate'] = endDate;
    data['entryFee'] = entryFee;
    data['image'] = image;
    data['isDeleted'] = isDeleted;
    data['joinedList'] = joinedList;
    data['lastDateToJoin'] = lastDateToJoin;
    data['location'] = location;
    data['runnerTeamId'] = runnerTeamId;
    data['terms'] = terms;
    data['title'] = title;
    data['uid'] = uid;
    data['winnerTeamId'] = winnerTeamId;
    data['winningPrize'] = winningPrize;
    return data;
  }
}
