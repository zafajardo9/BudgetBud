import 'package:flutter/material.dart';

class ItemSelectionModal extends StatefulWidget {
  final List<String> items;
  final String selectedItem;

  const ItemSelectionModal({
    Key? key,
    required this.items,
    required this.selectedItem,
  }) : super(key: key);

  @override
  _ItemSelectionModalState createState() => _ItemSelectionModalState();
}

class _ItemSelectionModalState extends State<ItemSelectionModal> {
  late String selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Item',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = widget.items[index];
                final isSelected = selectedItem == item;

                return ListTile(
                  title: Text(
                    item,
                    style: TextStyle(
                      color: isSelected ? Colors.blue : null,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedItem = item;
                    });
                  },
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: Colors.blue)
                      : null,
                );
              },
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, selectedItem);
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }
}
