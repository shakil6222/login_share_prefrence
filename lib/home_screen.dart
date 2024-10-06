import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_share_prefrence/login_screen.dart';
import 'package:login_share_prefrence/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<String> itemList = []; // Stores list of items
  TextEditingController itemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadItems(); // Load items when the app starts
  }

  void loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      itemList = prefs.getStringList('items') ?? [];
    });
  }

  void addNewUser(String item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    itemList.add(item);
    prefs.setStringList('items', itemList);
    setState(() {});
  }

  void updateUser(int index, String newItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    itemList[index] = newItem;
    prefs.setStringList('items', itemList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        title: const Text(
          "Crude SharePref",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
              padding: const EdgeInsets.only(right: 10),
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Fluttertoast.showToast(msg: "Notification");
              }),
          IconButton(
            onPressed: () async {
              bool isLogin = false;
              Fluttertoast.showToast(msg: "User LogOut");
              var logOut = await SharedPreferences.getInstance();
              // logOuut Code
              logOut.setBool('isLogin', isLogin);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            icon: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.logout,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showBotomShift();
      },
        backgroundColor: Colors.blue,
        child:Icon(Icons.add),
      ),
      body:
      Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(itemList[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showEditDialog(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          simpleAlertDialog(
                              title: "Delete Cache",
                              description: "Are You Want to Delete",
                              index: 0);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: 300,
            child:
            Padding(
              padding: const EdgeInsets.only(bottom: 220),
              child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green)),
                onPressed: () {
                  if (itemController.text.isNotEmpty) {
                    addNewUser(itemController.text);
                    itemController.clear();
                  }

                },
                child: const Text(
                  "Save User",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showEditDialog(int index) {
    TextEditingController editController =
        TextEditingController(text: itemList[index]);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit User"),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              labelText: "New Name",
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.green)),
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  updateUser(index, editController.text);
                  Navigator.pop(context);
                }
              },
              child: Text("Update"),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.green)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    itemList.removeAt(index);
    prefs.setStringList('items', itemList);
    setState(() {});
  }

  void simpleAlertDialog(
      {required String title,
      required String description,
      required int index}) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        shadowColor: Colors.red,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 30,
            letterSpacing: 1,
          ),
        ),
        content: Text(
          "$description",
          style: const TextStyle(
            color: Colors.orange,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, "Canceled"),
            child: const Text(
              "No",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Fluttertoast.showToast(msg: "Delete Success");
              // Delete Item
              SharedPreferences prefs = await SharedPreferences.getInstance();
              itemList.removeAt(index);
              prefs.setStringList('items', itemList);
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  void showBotomShift() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width * 1,
          height: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child:
          Padding(padding: EdgeInsets.all(30),
          child:
          TextField(
            controller: itemController,
            decoration:  const InputDecoration(
              labelText: 'Enter Your Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
              
            ),
          ),),
        );
      },
    );
  }
}
