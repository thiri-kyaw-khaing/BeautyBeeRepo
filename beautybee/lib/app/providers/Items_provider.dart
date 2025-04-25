import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ItemsProvider with ChangeNotifier {
  late Box _box;
  List<Map> _items = [];
  String currentList = "";

  List<Map> get items => _items;

  Future<void> loadItems(String listName) async {
    currentList = listName;
    _box = await Hive.openBox('shopping_list_items_$listName');
    _items = _box.values.cast<Map>().toList();
    notifyListeners();
  }

  void addItem(String name, String qty) {
    _box.add({'name': name, 'qty': qty, 'bought': false});
    loadItems(currentList);
  }

  void toggleBought(int index) {
    final item = _box.getAt(index);
    _box.putAt(index, {
      'name': item['name'],
      'qty': item['qty'],
      'bought': !(item['bought'] ?? false),
    });
    loadItems(currentList);
  }

  void deleteItem(int index) {
    _box.deleteAt(index);
    loadItems(currentList);
  }
}
