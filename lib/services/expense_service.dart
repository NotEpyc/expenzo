import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseService {
  static final ExpenseService _instance = ExpenseService._internal();
  factory ExpenseService() => _instance;
  ExpenseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'expense';

  Future<String> addExpense(Expense expense) async {
    try {
      final expenseData = {
        'date': Timestamp.fromDate(expense.date),
        'categoryName': expense.categoryName,
        'vendorName': expense.vendorName,
        'items': expense.items.map((item) => item.toJson()).toList(),
        'totalBilling': expense.totalBilling,
        'paid': expense.paid,
        'paymentMode': expense.paymentMode,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final DocumentReference docRef = await _firestore
          .collection(_collectionName)
          .add(expenseData);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add expense: $e');
    }
  }

  Future<String> createExpenseWithoutItems(Expense expense) async {
    try {
      final expenseData = {
        'date': Timestamp.fromDate(expense.date),
        'categoryName': expense.categoryName,
        'vendorName': expense.vendorName,
        'itemIds': <String>[],
        'totalBilling': expense.totalBilling,
        'paid': expense.paid,
        'paymentMode': expense.paymentMode,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final DocumentReference docRef = await _firestore
          .collection(_collectionName)
          .add(expenseData);

      await docRef.update({'id': docRef.id});

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create expense: $e');
    }
  }

  Future<String> createMinimalExpense() async {
    try {
      final expenseData = {
        'date': Timestamp.fromDate(DateTime.now()),
        'categoryName': '',
        'vendorName': null,
        'itemIds': <String>[],
        'totalBilling': 0.0,
        'paid': 0.0,
        'paymentMode': 'Please Select',
        'createdAt': FieldValue.serverTimestamp(),
        'isComplete': false,
      };

      final DocumentReference docRef = await _firestore
          .collection(_collectionName)
          .add(expenseData);

      await docRef.update({'id': docRef.id});

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create minimal expense: $e');
    }
  }

  Future<void> updateExpenseWithItemIds(String expenseId, List<String> itemIds) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(expenseId)
          .update({'itemIds': itemIds});
    } catch (e) {
      throw Exception('Failed to update expense with item IDs: $e');
    }
  }

  Future<List<Expense>> getAllExpenses() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .where('isComplete', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        DateTime date;
        if (data['date'] is Timestamp) {
          date = (data['date'] as Timestamp).toDate();
        } else if (data['date'] is int) {
          date = DateTime.fromMillisecondsSinceEpoch(data['date']);
        } else {
          date = DateTime.now();
        }

        DateTime? createdAt;
        if (data['createdAt'] != null) {
          if (data['createdAt'] is Timestamp) {
            createdAt = (data['createdAt'] as Timestamp).toDate();
          } else if (data['createdAt'] is int) {
            createdAt = DateTime.fromMillisecondsSinceEpoch(data['createdAt']);
          }
        }

        List<ExpenseItem> items = [];
        if (data['items'] is List) {
          items = (data['items'] as List<dynamic>)
              .map((item) => ExpenseItem.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return Expense(
          id: doc.id,
          date: date,
          categoryName: data['categoryName'] ?? '',
          vendorName: data['vendorName'],
          items: items,
          totalBilling: (data['totalBilling'] as num?)?.toDouble() ?? 0.0,
          paid: (data['paid'] as num?)?.toDouble() ?? 0.0,
          paymentMode: data['paymentMode'] ?? '',
          createdAt: createdAt,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get expenses: $e');
    }
  }

  Future<List<Expense>> getExpensesByCategory(String categoryName) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .where('categoryName', isEqualTo: categoryName)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        DateTime date;
        if (data['date'] is Timestamp) {
          date = (data['date'] as Timestamp).toDate();
        } else if (data['date'] is int) {
          date = DateTime.fromMillisecondsSinceEpoch(data['date']);
        } else {
          date = DateTime.now();
        }

        DateTime? createdAt;
        if (data['createdAt'] != null) {
          if (data['createdAt'] is Timestamp) {
            createdAt = (data['createdAt'] as Timestamp).toDate();
          } else if (data['createdAt'] is int) {
            createdAt = DateTime.fromMillisecondsSinceEpoch(data['createdAt']);
          }
        }

        List<ExpenseItem> items = [];
        if (data['items'] is List) {
          items = (data['items'] as List<dynamic>)
              .map((item) => ExpenseItem.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return Expense(
          id: doc.id,
          date: date,
          categoryName: data['categoryName'] ?? '',
          vendorName: data['vendorName'],
          items: items,
          totalBilling: (data['totalBilling'] as num?)?.toDouble() ?? 0.0,
          paid: (data['paid'] as num?)?.toDouble() ?? 0.0,
          paymentMode: data['paymentMode'] ?? '',
          createdAt: createdAt,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get expenses by category: $e');
    }
  }

  Future<void> updateExpense(String expenseId, Expense expense) async {
    try {
      final expenseData = {
        'date': Timestamp.fromDate(expense.date),
        'categoryName': expense.categoryName,
        'vendorName': expense.vendorName,
        'items': expense.items.map((item) => item.toJson()).toList(),
        'totalBilling': expense.totalBilling,
        'paid': expense.paid,
        'paymentMode': expense.paymentMode,
        'isComplete': true,
      };

      await _firestore
          .collection(_collectionName)
          .doc(expenseId)
          .update(expenseData);
    } catch (e) {
      throw Exception('Failed to update expense: $e');
    }
  }

  Future<void> updateExpenseFields(String expenseId, Map<String, dynamic> fields) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(expenseId)
          .update(fields);
    } catch (e) {
      throw Exception('Failed to update expense fields: $e');
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(expenseId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  Future<Map<String, double>> getExpenseStats() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .get();

      double totalExpenses = 0.0;
      double totalPaid = 0.0;
      double totalPending = 0.0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final totalBilling = (data['totalBilling'] as num?)?.toDouble() ?? 0.0;
        final paid = (data['paid'] as num?)?.toDouble() ?? 0.0;

        totalExpenses += totalBilling;
        totalPaid += paid;
        totalPending += (totalBilling - paid);
      }

      return {
        'totalExpenses': totalExpenses,
        'totalPaid': totalPaid,
        'totalPending': totalPending,
      };
    } catch (e) {
      throw Exception('Failed to get expense statistics: $e');
    }
  }
}
