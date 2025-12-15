import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

class InventoryProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  String _sortBy = 'default';

  // Master list of all products from Firestore
  List<Product> _products = [];
  List<Product> get products => _products;

  // Filtered list shown in UI
  List<Product> _filteredProducts = [];
  List<Product> get filteredProducts => _filteredProducts;

  // Search and filter states
  String _searchQuery = '';
  String _selectedCategory = 'All'; // 'All' means no filter
  String get selectedCategory => _selectedCategory;

  // Loading state
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // List of unique categories (for filter chips)
  Set<String> get categories {
    Set<String> cats = {'All'};
    for (var product in _products) {
      cats.add(product.category);
    }
    return cats;
  }

  InventoryProvider() {
    _loadProducts();
  }

  void setSortBy(String sortType) {
    _sortBy = sortType;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void _applyFiltersAndSort() {
    List<Product> temp = _products;

    // Apply search
    if (_searchQuery.isNotEmpty) {
      temp = temp.where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      temp = temp.where((product) => product.category == _selectedCategory).toList();
    }

    // Apply sorting
    if (_sortBy == 'category') {
      temp.sort((a, b) => a.category.compareTo(b.category));
    }
    // 'default' = no extra sort (Firestore returns in natural order, usually newest first)

    _filteredProducts = temp;
  }

  // Load and listen to real-time updates
  void _loadProducts() {
    _isLoading = true;
    notifyListeners();

    _firestoreService.getProductsStream().listen((List<Product> productList) {
      _products = productList;
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    });
  }

  // Apply search + category filter
  void _applyFilters() {
    List<Product> temp = _products;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      temp = temp.where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      temp = temp.where((product) => product.category == _selectedCategory).toList();
    }

    _filteredProducts = temp;
  }

  // Public methods for UI to call

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _applyFilters();
    notifyListeners();
  }

  // CRUD operations
  Future<void> addProduct(Product product) async {
    await _firestoreService.addProduct(product);
    // No need to notifyListeners() here – stream will handle it
  }

  Future<void> updateProduct(Product product) async {
    await _firestoreService.updateProduct(product);
  }

  Future<void> deleteProduct(String productId) async {
    await _firestoreService.deleteProduct(productId);
  }

  // Helper: Get total products and low stock count for dashboard
  int get totalProducts => _products.length;

  int get lowStockCount {
    return _products.where((p) => p.quantity < 10).length; // Alert if < 10
  }
}