import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTest {
  static Future<void> addTestData() async {
    await FirebaseFirestore.instance.collection('test').add({
      'message': 'Hello from JustBus',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
