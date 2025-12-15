import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Add a new product
  Future<void> addProduct(Product product) async {
    await _db.collection(_collection).add(product.toMap());
  }

  // Update an existing product
  Future<void> updateProduct(Product product) async {
    if (product.id == null) {
      throw Exception("Product ID is required for update");
    }
    await _db.collection(_collection).doc(product.id).set(product.toMap(), SetOptions(merge: true));
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    await _db.collection(_collection).doc(productId).delete();
  }

  // Get real-time stream of all products
  Stream<List<Product>> getProductsStream() {
    return _db.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Optional: Get products once (not real-time)
  Future<List<Product>> getProducts() async {
    QuerySnapshot snapshot = await _db.collection(_collection).get();
    return snapshot.docs.map((doc) {
      return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}