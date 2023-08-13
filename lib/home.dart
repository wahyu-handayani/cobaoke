import 'package:flutter/material.dart';
import 'package:hapus/repo.dart';

class Item {
  final int id;
  final String name;

  Item({required this.id, required this.name});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(id: json['id'], name: json['title']);
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Item> itemList = [];

  @override
  void initState() {
    super.initState();
    apiGet();
  }

  apiGet() {
    ApiAll().apiGet().then((res) {
      List<dynamic> data = res;
      itemList = data.map((itemJson) => Item.fromJson(itemJson)).toList();
      setState(() {});
    });
  }

  hapusVoid(int index) {
    ApiAll().hapusVoid(itemList[index].id).then((res) {
      setState(() {
        itemList.removeAt(index);
      });
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
    });
  }

  updateItem(int id, String newName) {
    ApiAll().updateItem(id, newName).then((res) {
      final updatedItem = Item.fromJson(res);
      final index = itemList.indexWhere((item) => item.id == id);
      setState(() {
        itemList[index] = updatedItem;
      });
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API Example')),
      body: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(itemList[index].name),
            onTap: () async {
              String newName = await showDialog(
                context: context,
                builder: (context) {
                  String updatedName = itemList[index].name;
                  return AlertDialog(
                    title: Text('Update Item'),
                    content: TextField(
                      onChanged: (value) {
                        updatedName = value;
                      },
                      controller:
                          TextEditingController(text: itemList[index].name),
                      decoration: InputDecoration(labelText: 'Item Name'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, null);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, updatedName);
                        },
                        child: Text('Update'),
                      ),
                    ],
                  );
                },
              );

              if (newName != null) {
                updateItem(itemList[index].id, newName);
              }
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => hapusVoid(index),
            ),
          );
        },
      ),
    );
  }
}
