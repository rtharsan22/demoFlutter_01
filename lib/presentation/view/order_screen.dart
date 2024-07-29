// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginui/presentation/themes/colors.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? _selectedDateTime;
  String? selectedFood;

  final List<String> foodItems = [
    'Kothu',
    'Noodles',
    'Pizza',
    'Burger',
    'Fried Rice'
  ];

  late CollectionReference myItems;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    myItems = FirebaseFirestore.instance.collection("123");
  }

  Future<void> submitOrder() async {
    final CollectionReference orders =
        FirebaseFirestore.instance.collection('order');
    if (formkey.currentState?.validate() ?? false) {
      final Map<String, dynamic> orderfields = {
        'food_name': selectedFood,
        'address': addressController.text,
        'city': cityController.text,
        'phone_num': phoneController.text,
        'description': descriptionController.text,
        'date_and_time': _selectedDateTime?.toString() ?? '',
      };

      try {
        await orders.add(orderfields);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order Submitted')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        print('Error submitting order: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit order')),
        );
      }
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          dateController.text =
              "${_selectedDateTime?.toLocal()}".split(' ')[0] +
                  ' ' +
                  pickedTime.format(context);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Center(
                child: Text(
                  "Order plz..",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "choose your favourite..",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: height * 0.1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DropdownButtonFormField<String>(
                  value: selectedFood,
                  hint: const Text("Select Food"),
                  items: foodItems.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedFood = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.restaurant,
                      color: primaryColor,
                    ),
                    labelText: "FOOD",
                    labelStyle: TextStyle(fontSize: 20),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a food item';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: TextFormField(
                  controller: addressController,
                  keyboardType: TextInputType.streetAddress,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: primaryColor,
                    ),
                    labelText: "Delivery address",
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the delivery address';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: TextFormField(
                  controller: cityController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    prefixIcon: Icon(
                      Icons.location_city,
                      color: primaryColor,
                    ),
                    labelText: "CITY",
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the city';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: primaryColor,
                    ),
                    labelText: "DATE AND TIME",
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    _selectDateTime(context);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the date and time';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: TextFormField(
                  controller: descriptionController,
                  minLines: 3,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    prefixIcon: Icon(
                      Icons.description,
                      color: primaryColor,
                    ),
                    labelText: "DESCRIPTION",
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: height * 0.1),
              Center(
                child: SizedBox(
                  height: height * 0.06,
                  width: width - 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onPressed: submitOrder,
                    child: const Text(
                      "ORDER NOW",
                      style: TextStyle(
                        letterSpacing: 0.5,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
