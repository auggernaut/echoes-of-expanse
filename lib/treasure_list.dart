import 'package:echoes_of_expanse/data.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TreasureList extends StatefulWidget {
  final Hand hand;
  final VoidCallback onUpdate;

  TreasureList({required this.hand, required this.onUpdate});

  @override
  _TreasureListState createState() => _TreasureListState();
}

class _TreasureListState extends State<TreasureList> {
  List<TreasureItem> items = [];
  Map<String, TextEditingController> _nameControllers = {};
  Map<String, TextEditingController> _costControllers = {};
  Map<String, TextEditingController> _weightControllers = {};

  @override
  void initState() {
    super.initState();
    items = List.from(widget.hand.treasureItems); // Create a local copy
    for (var item in items) {
      _nameControllers[item.id] = TextEditingController(text: item.name);
      _costControllers[item.id] = TextEditingController(text: item.cost.toString());
      _weightControllers[item.id] = TextEditingController(text: item.weight.toString());
    }
  }

  void _addItem() {
    setState(() {
      var newItem = TreasureItem(id: Uuid().v4(), name: '', cost: 0, weight: 0);
      items.add(newItem);
      widget.hand.addTreasureItem(newItem);
      _nameControllers[newItem.id] = TextEditingController(text: newItem.name);
      _costControllers[newItem.id] = TextEditingController(text: newItem.cost.toString());
      _weightControllers[newItem.id] = TextEditingController(text: newItem.weight.toString());
      widget.onUpdate();
    });
  }

  void _removeItem(String id) {
    setState(() {
      widget.hand.removeTreasureItem(id);
      items.removeWhere((item) => item.id == id);
      _nameControllers.remove(id);
      _costControllers.remove(id);
      _weightControllers.remove(id);
      widget.onUpdate();
    });
  }

  void _updateItem(TreasureItem updatedItem) {
    setState(() {
      int index = items.indexWhere((item) => item.id == updatedItem.id);
      if (index != -1) {
        items[index] = updatedItem;
        widget.hand.updateTreasureItem(updatedItem);
        widget.onUpdate();
      }
    });
  }

  Widget _buildItemRow(int index) {
    TreasureItem item = items[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.store),
            onPressed: () => _removeItem(item.id),
          ),
          Expanded(
            flex: 8,
            child: TextField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Item name', // Placeholder for item name
                isDense: true,
                contentPadding: EdgeInsets.all(8),
              ),
              controller: _nameControllers[item.id],
              onChanged: (value) {
                _updateItem(TreasureItem(
                  id: item.id,
                  name: value,
                  cost: item.cost,
                  weight: item.weight,
                ));
              },
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Cost', // Placeholder for cost
                isDense: true,
                contentPadding: EdgeInsets.all(8),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              controller: _costControllers[item.id],
              onChanged: (value) {
                int cost = int.tryParse(value) ?? 0;
                _updateItem(TreasureItem(
                  id: item.id,
                  name: item.name,
                  cost: cost,
                  weight: item.weight,
                ));
              },
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Weight', // Placeholder for weight
                isDense: true,
                contentPadding: EdgeInsets.all(8),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              controller: _weightControllers[item.id],
              onChanged: (value) {
                int weight = int.tryParse(value) ?? 0;
                _updateItem(TreasureItem(
                  id: item.id,
                  name: item.name,
                  cost: item.cost,
                  weight: weight,
                ));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreasureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                flex: 8,
                child: Text(
                  'Treasure',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Expanded(flex: 2, child: Icon(Icons.circle, color: Colors.black.withOpacity(0.2))),
            Expanded(
                flex: 2, child: Icon(Icons.fitness_center, color: Colors.black.withOpacity(0.2))),
          ],
        ),
        ...items.asMap().entries.map((entry) {
          int index = entry.key;
          return _buildItemRow(index);
        }).toList(),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addItem,
          child: Text('Add Item'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTreasureSection();
  }
}
