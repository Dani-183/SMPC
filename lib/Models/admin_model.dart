import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  String? uid, email, name, location, image, phoneNo, aboutCollege, bankAccountTitle, bankName, bankIBAN;
  bool? isVerified, isDeleted;
  DateTime? joinedAt;

  AdminModel({
    this.aboutCollege,
    this.bankAccountTitle,
    this.bankIBAN,
    this.bankName,
    this.email,
    this.image,
    this.isDeleted,
    this.isVerified,
    this.joinedAt,
    this.location,
    this.name,
    this.phoneNo,
    this.uid,
  });

  AdminModel.fromFirestore(DocumentSnapshot doc) {
    aboutCollege = doc.get('aboutCollege');
    bankAccountTitle = doc.get('bankAccountTitle');
    bankIBAN = doc.get('bankIBAN');
    bankName = doc.get('bankName');
    email = doc.get('email');
    image = doc.get('image');
    isDeleted = doc.get('isDeleted');
    isVerified = doc.get('isVerified');
    joinedAt = (doc.get('joinedAt') as Timestamp).toDate();
    location = doc.get('location');
    name = doc.get('name');
    phoneNo = doc.get('phoneNo');
    uid = doc.get('uid');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['aboutCollege'] = aboutCollege;
    data['bankAccountTitle'] = bankAccountTitle;
    data['bankIBAN'] = bankIBAN;
    data['bankName'] = bankName;
    data['email'] = email;
    data['image'] = image;
    data['isDeleted'] = isDeleted;
    data['isVerified'] = isVerified;
    data['joinedAt'] = joinedAt;
    data['location'] = location;
    data['name'] = name;
    data['phoneNo'] = phoneNo;
    data['uid'] = uid;
    return data;
  }

  Map<String, dynamic> toUpdateJson() {
    final data = <String, dynamic>{};
    aboutCollege == null ? null : data['aboutCollege'] = aboutCollege;
    bankAccountTitle == null ? null : data['bankAccountTitle'] = bankAccountTitle;
    bankIBAN == null ? null : data['bankIBAN'] = bankIBAN;
    bankName == null ? null : data['bankName'] = bankName;
    image == null ? null : data['image'] = image;
    isDeleted == null ? null : data['isDeleted'] = isDeleted;
    isVerified == null ? null : data['isVerified'] = isVerified;
    location == null ? null : data['location'] = location;
    name == null ? null : data['name'] = name;
    phoneNo == null ? null : data['phoneNo'] = phoneNo;
    return data;
  }
}
