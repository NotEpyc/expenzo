import 'package:flutter/foundation.dart';
import '../models/expense_category.dart';
import '../services/expense_category_service.dart';

class HomeController extends ChangeNotifier {
  final ExpenseCategoryService _categoryService = ExpenseCategoryService();
  
  int _selectedTabIndex = 1;
  List<ExpenseCategory> _categories = [];
  bool _isLoading = false;

  int get selectedTabIndex => _selectedTabIndex;
  List<ExpenseCategory> get categories => _categories;
  bool get isLoading => _isLoading;

  HomeController() {
    _loadCategories();
  }

  void _loadCategories() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _categories = await _categoryService.getAllCategories();
    } catch (e) {
      debugPrint('Error loading categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void changeTab(int index) {
    if (index == 1) {
      _selectedTabIndex = index;
      notifyListeners();
    }
  }

  void addCategory(String categoryName) async {
    if (categoryName.trim().isEmpty) return;
    
    final newCategory = ExpenseCategory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: categoryName.trim(),
      hasIcon: true,
      isCompleted: true,
    );
    
    try {
      await _categoryService.addCategory(newCategory);
      _loadCategories();
    } catch (e) {
      debugPrint('Error adding category: $e');
    }
  }

  void toggleCategoryCompletion(String categoryId) {
    _categoryService.toggleCategoryCompletion(categoryId);
    _loadCategories();
  }

  void deleteCategory(String categoryId) {
    _categoryService.deleteCategory(categoryId);
    _loadCategories();
  }

  void onCategoryTap(String categoryId) {
    debugPrint('Category tapped: $categoryId');
  }

  void onSearch(String query) {
    debugPrint('Searching for: $query');
  }

  void onAddButtonTap() {
    debugPrint('Add button tapped');
  }
}
