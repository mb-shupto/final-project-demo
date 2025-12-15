import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get current user UID
  String? get _currentUid => FirebaseAuth.instance.currentUser?.uid;

  // Reference to user's products subcollection
  CollectionReference get _userProductsRef {
    if (_currentUid == null) {
      throw Exception('User not authenticated');
    }
    return _db.collection('users').doc(_currentUid).collection('products');
  }

  // Add product
  Future<void> addProduct(Product product) async {
    await _userProductsRef.add(product.toMap());
  }

  // Update product
  Future<void> updateProduct(Product product) async {
    if (product.id == null) throw Exception('Product ID required');
    await _userProductsRef.doc(product.id).set(product.toMap(), SetOptions(merge: true));
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    await _userProductsRef.doc(productId).delete();
  }

  // Real-time stream of user's products
  Stream<List<Product>> getProductsStream() {
    return _userProductsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}