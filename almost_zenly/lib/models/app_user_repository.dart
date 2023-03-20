import 'package:almost_zenly/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserRepository {
  static Stream<List<AppUser>> getAppUserStream() {
    return FirebaseFirestore.instance.collection('app_users').snapshots().map(
          (snp) => snp.docs
              .map((doc) => AppUser.fromDoc(doc.id, doc.data()))
              .toList(),
        );
  }
}
