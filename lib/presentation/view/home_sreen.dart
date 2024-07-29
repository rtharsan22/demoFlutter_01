// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginui/presentation/themes/colors.dart';
import 'edit_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference orders = // Firestore collection named 'order'.
      FirebaseFirestore.instance.collection('order');

  Stream<QuerySnapshot> getOrderStream() {
    return orders.snapshots();
  } //Returns of snapshots from the 'order', providing real time updates.

  Future<void> deleteOrder(String orderId) async {
    try {
      //Deletes order from the Firestore by document ID
      await orders.doc(orderId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your order has been cancelled')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to cancel the order')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: const SizedBox(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Delivering to",
              style: TextStyle(color: primaryColor, fontSize: 15),
            ),
            GestureDetector(
              onTap: () {
                print("clicked");
              },
              child: const Row(
                children: [
                  Text(
                    "Current location",
                    style: TextStyle(color: Colors.black54, fontSize: 24),
                  ),
                  Icon(Icons.keyboard_arrow_down,
                      color: primaryColor, size: 30),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), //signOut
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        //Uses a StreamBuilder to listen to real-time updates from the Firestore

        stream: getOrderStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;
          print('----- database data ${data.size}');

          return ListView.builder(
            //Displays a list of orders
            itemCount: data.size,
            itemBuilder: (context, index) {
              var order = data.docs[index];
              return Card(
                child: ListTile(
                  title: Text(order['food_name'] ?? ''),
                  subtitle: Text(order['date_and_time'] ?? ''),
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1547721064-da6cfb341d50",
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit,
                            color: Color.fromARGB(255, 149, 109, 0)),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPage(order: order),
                            ),
                          );
                          if (result == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Your changes have been saved')),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Color.fromARGB(255, 180, 115, 41)),
                        onPressed: () async {
                          await deleteOrder(order.id);
                        },
                      ),
                    ],
                  ),
                  onTap: null,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 253, 123, 0),
        tooltip: 'Add Order',
        onPressed: () {
          Navigator.pushNamed(
              context, '/order'); //click and navigate after logoff
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
