import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryModel {
  String? uid, imageUrl, uploadedBy;
  DateTime? uploadedAt;

  GalleryModel({this.imageUrl, this.uid, this.uploadedAt, this.uploadedBy});

  GalleryModel.fromFirestore(DocumentSnapshot doc) {
    imageUrl = doc.get('imageUrl');
    uid = doc.get('uid');
    uploadedAt = (doc.get('uploadedAt') as Timestamp).toDate();
    uploadedBy = doc.get('uploadedBy');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['imageUrl'] = imageUrl;
    data['uid'] = uid;
    data['uploadedAt'] = uploadedAt;
    data['uploadedBy'] = uploadedBy;
    return data;
  }
}
