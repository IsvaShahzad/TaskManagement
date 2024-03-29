import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HomeScreen());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const DeleteTaskScreen(),
    );
  }
}




class DeleteTaskScreen extends StatefulWidget {
  const DeleteTaskScreen({
    super.key,
  });




  @override
  State<DeleteTaskScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DeleteTaskScreen> {
  bool isDelete = false;
  int? selectedTaskIndex;

  bool uploading = false;
  var allData;
  String? userRole; // Add a variable to store the user's role

  List<String> lis3 = [];
  String selectedShop = "Select Event";
  late List<dynamic> addedTask;

  getData() async {
    CollectionReference collection =
    FirebaseFirestore.instance.collection('Tasks');

    // Retrieve user role
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      if (userDoc.exists && userDoc.get('role') != null) {
        userRole = userDoc.get('role');
      }
    }

    QuerySnapshot snapshot = await collection.get();

    lis3.clear();
    lis3.add("Select Event");

    for (var element in snapshot.docs) {
      Map<String, dynamic>? documentData =
      element.data() as Map<String, dynamic>?;

      if (documentData != null && documentData.containsKey('AddedTasks')) {
        addedTask = documentData['AddedTasks'];

        for (var task in addedTask) {
          if (task is Map<String, dynamic> && task.containsKey('title')) {
            lis3.add(task['title'].toString());
          }
        }
      }
    }

    allData = snapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  Future<void> sendEmail() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final smtpServer = gmail('isvashaz@gmail.com', 'ncsq nugn gdof vdim');

      final message = Message()
        ..from = Address('isvashaz@gmail.com', 'EZI Task Manager')
        ..recipients.add(user.email!) // Use the user's email
        ..subject = 'Task Updated!'
        ..text = '''
       
      ''';

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } catch (e) {
        print('Error sending email: $e');
      }
    } else {
      print('User is not logged in');
    }
  }


  Widget _customPopupItemBuilderExample2(BuildContext context, String item,
      bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme
            .of(context)
            .primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            child: Padding(
              padding:
              const EdgeInsets.only(top: 20), // Add your desired spacing here
              child: FutureBuilder(
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.black54),
                        ));
                  } else {
                    return ListView(
                      children: [
                        Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(9),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200], // Grey color
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                                child: TextField(
                                  enabled: false,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                    ),
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.black12, width: 0.0),
                                      borderRadius: BorderRadius.circular(9.0),
                                    ),
                                    fillColor: Colors.grey[200],
                                    // Grey color
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 8, bottom: 8),
                              child: DropdownSearch<String>(
                                dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search Event by Name',
                                    fillColor: Colors.grey, // Grey color
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                items: lis3,
                                compareFn: (i, s) => i == s,
                                selectedItem: selectedShop,
                                onChanged: (value) {
                                  selectedShop = value!;
                                  setState(() {});
                                },
                                popupProps: PopupPropsMultiSelection.dialog(
                                  isFilterOnline: true,
                                  showSelectedItems: true,
                                  searchFieldProps: const TextFieldProps(
                                    decoration: InputDecoration(
                                      labelText: 'Search',
                                      prefixIcon: Icon(Icons.search),
                                    ),
                                  ),
                                  showSearchBox: true,
                                  itemBuilder: _customPopupItemBuilderExample2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        uploading
                            ? Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 12),
                          child: const CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation(Colors.black54),
                          ),
                        )
                            : const Text(''),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (selectedShop != "Select Event") {
                                if (addedTask[index]["title"] != selectedShop) {
                                  return const SizedBox(height: 0);
                                } else {
                                  return GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        selectedTaskIndex = index;
                                      });

                                      await _showDeleteDialog(addedTask[index]["title"]);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                      child: AspectRatio(
                                        aspectRatio: 2.5, // Adjust the aspect ratio as needed
                                        child: Card(
                                          color: Colors.grey[200],
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Title: ${addedTask[index]["title"]}",
                                                          style: TextStyle(
                                                            color: Colors.grey[700],
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        // Keep the status text here
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      "Description: ${addedTask[index]["description"]}",
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      "Status: ${addedTask[index]["status"]}",
                                                      style: TextStyle(
                                                        color: Colors.purple,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: IconButton(
                                                  icon: Icon(Icons.edit, color: Colors.red[700]),
                                                  onPressed: () {
                                                    _openEditDialog(addedTask[index]);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              } else {
// Inside your ListView.builder
                                return GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      selectedTaskIndex = index;
                                    });

                                    await _showDeleteDialog(addedTask[index]["title"]);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                    child: AspectRatio(
                                      aspectRatio: 2.5,
                                      child: Card(
                                        color: Colors.grey[200],
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Title: ${addedTask[index]["title"]}",
                                                        style: TextStyle(
                                                          color: Colors.grey[700],
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      // Keep the status text here
                                                    ],
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    "Description: ${addedTask[index]["description"]}",
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    "Status: ${addedTask[index]["status"]}",
                                                    style: TextStyle(
                                                      color: Colors.purple,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: userRole == 'admin' || userRole == 'manager'
                                                  ? IconButton(
                                                icon: Icon(Icons.edit, color: Colors.red[700]),
                                                onPressed: () {
                                                  _openEditDialog(addedTask[index]);
                                                },
                                              )
                                                  : Container(), // Empty container if the user is not admin or manager
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            itemCount: addedTask.length,
                          ),
                        ),
                      ],
                    );
                  }
                },
                future: getData(),
              ),
            )));
  }

  Future<void> _showDeleteDialog(String taskNameToDelete) async {
    bool isDeleting = false;
    if (userRole == 'admin') {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Attention'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Do you really want to delete $taskNameToDelete Event?'),
                ],
              ),
            ),
            actions: <Widget>[
              if (!isDeleting)
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () async {
                    setState(() {
                      isDeleting = true;
                    });
                    uploading = true;
                    final FirebaseFirestore firestore =
                        FirebaseFirestore.instance;

                    final CollectionReference redeemCollection =
                    firestore.collection("Tasks");

                    QuerySnapshot querySnapshot = await redeemCollection.get();

                    for (QueryDocumentSnapshot documentSnapshot
                    in querySnapshot.docs) {
                      Map<String, dynamic>? userData =
                      documentSnapshot.data() as Map<String, dynamic>?;
                      if (userData!.containsKey("AddedTasks")) {
                        List<Map<String, dynamic>> updatedRedeemTask = [];

                        for (var task in addedTask) {
                          if (task is Map<String, dynamic> &&
                              task["title"] != taskNameToDelete) {
                            updatedRedeemTask.add(task);
                          }
                        }
                        await documentSnapshot.reference
                            .update({"AddedTasks": updatedRedeemTask});
                      }
                    }
                    Fluttertoast.showToast(
                      msg: "Event Deleted",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      fontSize: 14,
                    );
                    uploading = false;
                    setState(() {
                      isDeleting = false;
                    });
                    // Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              if (isDeleting)
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.black54),
                  ),
                ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Display a message or handle the scenario where the user doesn't have delete permissions
      print('User does not have permission to delete.');
    }
  }

  void _openEditDialog(Map<String, dynamic> taskData) {
    setState(() {
      selectedTaskIndex = addedTask.indexOf(taskData);
    });

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            TextEditingController titleController =
            TextEditingController(text: taskData['title']);
            TextEditingController descriptionController =
            TextEditingController(text: taskData['description']);
            TextEditingController statusController =
            TextEditingController(text: taskData['status']);

            return AlertDialog(
              title: const Text('Edit Event'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Title:'),
                    TextField(controller: titleController),
                    SizedBox(height: 16),
                    Text('Description:'),
                    TextField(controller: descriptionController),
                    SizedBox(height: 16),
                    Text('Status:'),
                    TextField(controller: statusController),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Save Changes'),
                  onPressed: () {
                    // Implement save logic
                    sendEmail();
                    _saveChanges(
                      titleController.text,
                      descriptionController.text,
                      statusController.text,
                    );
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> updateFirestoreData(
      List<Map<String, dynamic>> updatedTasks) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference tasksCollection = firestore.collection("Tasks");
    QuerySnapshot querySnapshot = await tasksCollection.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic>? userData =
      documentSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey("AddedTasks")) {
        await documentSnapshot.reference.update({"AddedTasks": updatedTasks});
      }
    }
  }

  Future<void> _saveChanges(String newTitle,
      String newDescription,
      String newStatus,) async {
    if (selectedTaskIndex != null && selectedTaskIndex! >= 0) {
      // Check the user's role
      if (userRole == 'admin' || userRole == 'manager') {
        // Update UI
        setState(() {
          // Assuming addedTask is a list of maps containing tasks
          addedTask[selectedTaskIndex!]["title"] = newTitle;
          addedTask[selectedTaskIndex!]["description"] = newDescription;
          addedTask[selectedTaskIndex!]["status"] = newStatus;
        });

        // Save changes to Firestore
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        final CollectionReference tasksCollection =
        firestore.collection("Tasks");

        // Update the document in the "Tasks" collection
        QuerySnapshot querySnapshot = await tasksCollection.get();

        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          Map<String, dynamic>? userData =
          documentSnapshot.data() as Map<String, dynamic>?;

          if (userData != null && userData.containsKey("AddedTasks")) {
            List<Map<String, dynamic>> updatedTasks = [];

            for (var task in addedTask) {
              updatedTasks.add(task);
            }

            await documentSnapshot.reference
                .update({"AddedTasks": updatedTasks});
          }
        }

        // Print the changes (you can remove this in your actual implementation)
        print('New Title: $newTitle');
        print('New Description: $newDescription');
        print('New Status: $newStatus');

        // Send email to the current logged-in user's email
        await _sendEmailToCurrentUser();
      } else {
        // Display a message or handle the scenario where the user doesn't have update permissions
        print('User does not have permission to update.');
      }
    }
  }

  Future<void> _sendEmailToCurrentUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch the user's email from Firestore using the UID
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          String userEmail = userSnapshot.get("email");
          print(
              "Current User Email: $userEmail"); // Add this line to print the email


          print('Email sent successfully');
        } else {
          print("User document not found in Firestore");
        }
      } else {
        print('User is not logged in');
      }
    } catch (error) {
      print('Error sending email: $error');
    }
  }
}
