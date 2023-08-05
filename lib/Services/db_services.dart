import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smpc/Constants/global_var.dart';
import 'package:smpc/Models/gallery_model.dart';
import 'package:smpc/Models/models.dart';

class DBServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String admin = 'Admin';
  static const String sports = 'Sports';
  static const String players = 'Players';
  static const String teams = 'Teams';
  static const String events = 'Events';
  static const String gallery = 'Gallery';

  Future<void> createAdmin(AdminModel adminModel) async {
    try {
      await _firestore.collection(admin).doc(adminModel.uid).set(adminModel.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<AdminModel?> getAdmin(String adminId) async {
    return await _firestore.collection(admin).doc(adminId).get().then((DocumentSnapshot doc) {
      return AdminModel.fromFirestore(doc);
    });
  }

  Future<void> updateAdmin(AdminModel adminModel) async {
    try {
      await _firestore.collection(admin).doc(adminModel.uid).update(adminModel.toUpdateJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addNewSports(SportsModel sportsModel) async {
    String uid = _firestore.collection(sports).doc().id;
    sportsModel.uid = uid;
    await _firestore.collection(sports).doc(uid).set(sportsModel.toJson());
  }

  Future<void> updateSports(SportsModel sportsModel) async {
    await _firestore.collection(sports).doc(sportsModel.uid).update(sportsModel.toUpdateJson());
  }

  Stream<List<SportsModel>> streamSports(String collegeId) {
    return _firestore
        .collection(sports)
        .where('isDeleted', isEqualTo: false)
        .where('collegeId', isEqualTo: collegeId)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<SportsModel> retVal = [];
      for (var doc in snapshot.docs) {
        retVal.add(SportsModel.fromFirestore(doc));
      }
      return retVal;
    });
  }

  Future<void> deleteSports(String sportsId) async {
    await _firestore.collection(sports).doc(sportsId).update({'isDeleted': true});
  }

  Future<void> addNewPlayer(PlayerModel playerModel) async {
    String uid = _firestore.collection(players).doc().id;
    playerModel.uid = uid;
    await _firestore.collection(players).doc(uid).set(playerModel.toJson());
  }

  Future<void> deletePlayer(String playerId) async {
    await _firestore.collection(players).doc(playerId).update({'isDeleted': true});
  }

  Future<void> updatePlayer(PlayerModel playerModel) async {
    await _firestore.collection(players).doc(playerModel.uid).update(playerModel.toUpdateJson());
  }

  Stream<List<PlayerModel>> streamPlayers(String collegeId) {
    return _firestore
        .collection(players)
        .where('isDeleted', isEqualTo: false)
        .where('collegeId', isEqualTo: collegeId)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<PlayerModel> retVal = [];
      for (var doc in snapshot.docs) {
        retVal.add(PlayerModel.fromFirestore(doc));
      }
      return retVal;
    });
  }

  Future<void> addNewTeam(TeamModel teamModel) async {
    String uid = _firestore.collection(teams).doc().id;
    teamModel.uid = uid;
    await _firestore.collection(teams).doc(uid).set(teamModel.toJson());
  }

  Stream<List<TeamModel>> streamTeams(String collegeId) {
    try {
      return _firestore
          .collection(teams)
          .where('isDeleted', isEqualTo: false)
          .where('collegeId', isEqualTo: collegeId)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        List<TeamModel> retVal = [];
        for (var doc in snapshot.docs) {
          retVal.add(TeamModel.fromFirestore(doc));
        }
        return retVal;
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteTeam(String teamId) async {
    await _firestore.collection(teams).doc(teamId).update({'isDeleted': true});
  }

  Future<void> updateTeam(TeamModel teamModel) async {
    await _firestore.collection(teams).doc(teamModel.uid).update(teamModel.toUpdateJson());
  }

  Future<void> updateTeamPlayer(String teamId, List playerIds) async {
    await _firestore.collection(teams).doc(teamId).update({'playersIds': playerIds});
  }

  Future<void> createNewEvent(EventModel eventModel) async {
    String uid = _firestore.collection(events).doc().id;
    eventModel.uid = uid;
    await _firestore.collection(events).doc(uid).set(eventModel.toJson());
  }

  Future<void> joinEvent(String eventId, String collegeId) async {
    await _firestore.collection(events).doc(eventId).update({
      'joinedList': FieldValue.arrayUnion([collegeId])
    });
  }

  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection(events).doc(eventId).update({'isDeleted': true});
  }

  Stream<List<EventModel>> streamEvents() {
    try {
      return _firestore
          .collection(events)
          .where('isDeleted', isEqualTo: false)
          .orderBy('lastDateToJoin', descending: false)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        List<EventModel> retVal = [];
        for (var doc in snapshot.docs) {
          retVal.add(EventModel.fromFirestore(doc));
        }
        return retVal;
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Stream<List<EventModel>> streamMyEvents(String collegeId) {
    try {
      return _firestore
          .collection(events)
          .where('isDeleted', isEqualTo: false)
          .where('createdBy', isEqualTo: collegeId)
          .orderBy('lastDateToJoin', descending: false)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        List<EventModel> retVal = [];
        for (var doc in snapshot.docs) {
          retVal.add(EventModel.fromFirestore(doc));
        }
        return retVal;
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> createGalleryImage(GalleryModel galleryModel) async {
    String uid = _firestore.collection(gallery).doc().id;
    galleryModel.uid = uid;
    await _firestore.collection(gallery).doc(uid).set(galleryModel.toJson());
  }

  Future<void> deleteGalleryImage(String uid) async {
    await _firestore.collection(gallery).doc(uid).delete();
  }

  Stream<List<GalleryModel>> streamGallery() {
    return _firestore.collection(gallery).snapshots().map((QuerySnapshot snapshot) {
      List<GalleryModel> retVal = [];
      for (var doc in snapshot.docs) {
        retVal.add(GalleryModel.fromFirestore(doc));
      }
      return retVal;
    });
  }

  Stream<List<GalleryModel>> streamAdminGallery() {
    return _firestore
        .collection(gallery)
        .where('uploadedBy', isEqualTo: userID.value)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<GalleryModel> retVal = [];
      for (var doc in snapshot.docs) {
        retVal.add(GalleryModel.fromFirestore(doc));
      }
      return retVal;
    });
  }
}
