import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class ItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'items';

  Future<String> addItem(Item item) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        ...item.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      await docRef.update({'id': docRef.id});
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }

  Future<List<String>> addItems(List<Item> items) async {
    try {
      final List<String> itemIds = [];
      
      for (final item in items) {
        final docRef = await _firestore.collection(_collection).add({
          ...item.toJson(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        await docRef.update({'id': docRef.id});
        itemIds.add(docRef.id);
      }
      
      return itemIds;
    } catch (e) {
      throw Exception('Failed to add items: $e');
    }
  }

  Future<List<Item>> getItemsByExpenseId(String expenseId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('expenseId', isEqualTo: expenseId)
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => Item.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get items: $e');
    }
  }

  Future<void> updateItem(Item item) async {
    try {
      await _firestore.collection(_collection).doc(item.id).update(item.toJson());
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  Future<void> deleteItem(String itemId) async {
    try {
      await _firestore.collection(_collection).doc(itemId).delete();
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }

  Future<void> deleteItemsByExpenseId(String expenseId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('expenseId', isEqualTo: expenseId)
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete items: $e');
    }
  }

  Future<double> getTotalItemPriceForExpense(String expenseId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('expenseId', isEqualTo: expenseId)
          .get();

      double total = 0.0;
      for (final doc in querySnapshot.docs) {
        final item = Item.fromJson(doc.data());
        total += item.price;
      }
      
      return total;
    } catch (e) {
      throw Exception('Failed to calculate total price: $e');
    }
  }

  Future<int> getTotalItemQuantityForExpense(String expenseId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('expenseId', isEqualTo: expenseId)
          .get();

      int total = 0;
      for (final doc in querySnapshot.docs) {
        final item = Item.fromJson(doc.data());
        total += item.quantity;
      }
      
      return total;
    } catch (e) {
      throw Exception('Failed to calculate total quantity: $e');
    }
  }

  Future<void> updateItemsExpenseId(String tempExpenseId, String realExpenseId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('expenseId', isEqualTo: tempExpenseId)
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'expenseId': realExpenseId});
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to update items with expense ID: $e');
    }
  }
}
