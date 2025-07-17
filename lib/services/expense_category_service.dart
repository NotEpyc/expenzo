import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense_category.dart';

class ExpenseCategoryService {
  static final ExpenseCategoryService _instance = ExpenseCategoryService._internal();
  factory ExpenseCategoryService() => _instance;
  ExpenseCategoryService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'categories';

  List<ExpenseCategory> _categories = [];
  bool _isLoaded = false;

  Future<List<ExpenseCategory>> getAllCategories() async {
    if (!_isLoaded) {
      await _loadCategoriesFromFirestore();
      _isLoaded = true;
    }
    
    _categories.sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) return 0;
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return a.createdAt!.compareTo(b.createdAt!);
    });
    
    return List.from(_categories);
  }

  Future<void> _loadCategoriesFromFirestore() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection(_collectionName).get();
      _categories = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        DateTime? createdAt;
        
        if (data['createdAt'] != null) {
          if (data['createdAt'] is Timestamp) {
            createdAt = (data['createdAt'] as Timestamp).toDate();
          } else if (data['createdAt'] is int) {
            createdAt = DateTime.fromMillisecondsSinceEpoch(data['createdAt']);
          }
        }
        
        return ExpenseCategory(
          id: doc.id,
          name: data['name'] ?? '',
          hasIcon: data['hasIcon'] ?? false,
          isCompleted: data['isCompleted'] ?? false,
          createdAt: createdAt,
        );
      }).toList();
    } catch (e) {
      final now = DateTime.now();
      _categories = [
        ExpenseCategory(
          id: 'local_1', 
          name: 'Grocery', 
          hasIcon: true, 
          isCompleted: false,
          createdAt: now.subtract(const Duration(minutes: 2)),
        ),
        ExpenseCategory(
          id: 'local_2', 
          name: 'Utilities', 
          hasIcon: true, 
          isCompleted: false,
          createdAt: now.subtract(const Duration(minutes: 1)),
        ),
      ];
    }
  }

  Future<void> addCategory(ExpenseCategory category) async {
    final now = DateTime.now();
    final newCategory = ExpenseCategory(
      id: now.millisecondsSinceEpoch.toString(),
      name: category.name,
      hasIcon: category.hasIcon,
      isCompleted: category.isCompleted,
      createdAt: now,
    );
    
    _categories.add(newCategory);
    await _saveCategoryToFirestore(newCategory);
    
    _categories.sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) return 0;
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return a.createdAt!.compareTo(b.createdAt!);
    });
  }

  Future<void> _saveCategoryToFirestore(ExpenseCategory category) async {
    try {
      await _firestore.collection(_collectionName).add({
        'name': category.name,
        'hasIcon': category.hasIcon,
        'isCompleted': category.isCompleted,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  void _saveCategories() {
  }

  void updateCategory(String id, ExpenseCategory updatedCategory) {
    final index = _categories.indexWhere((category) => category.id == id);
    if (index != -1) {
      _categories[index] = updatedCategory;
      _saveCategories();
    }
  }

  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    _saveCategories();
  }

  ExpenseCategory? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  void toggleCategoryCompletion(String id) {
    final index = _categories.indexWhere((category) => category.id == id);
    if (index != -1) {
      _categories[index] = _categories[index].copyWith(
        isCompleted: !_categories[index].isCompleted,
      );
      _saveCategories();
    }
  }
}
