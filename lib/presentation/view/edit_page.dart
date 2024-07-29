import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginui/presentation/themes/colors.dart';

class EditPage extends StatefulWidget {
  final DocumentSnapshot order;

  const EditPage({super.key, required this.order});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController dateController;
  late TextEditingController cityController;
  late TextEditingController addressController;
  late TextEditingController descriptionController;

  DateTime? _selectedDateTime;
  String? selectedFood;

  final List<String> foodItems = [
    'Kothu',
    'Noodles',
    'Pizza',
    'Burger',
    'Fried Rice'
  ];

  @override
  void initState() {
    super.initState();
    selectedFood = widget.order['food_name'];
    dateController = TextEditingController(text: widget.order['date_and_time']);
    cityController = TextEditingController(text: widget.order['city']);
    addressController = TextEditingController(text: widget.order['address']);
    descriptionController =
        TextEditingController(text: widget.order['description']);
  }

  Future<void> saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      final Map<String, dynamic> updatedOrder = {
        'food_name': selectedFood,
        'date_and_time': _selectedDateTime?.toString() ?? '',
        'city': cityController.text,
        'address': addressController.text,
        'description': descriptionController.text,
      };
      try {
        await FirebaseFirestore.instance
            .collection('order')
            .doc(widget.order.id)
            .update(updatedOrder);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your changes saved')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save changes')),
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
                  '   ' +
                  pickedTime.format(context);
        });
      }
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    cityController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Order',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
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
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Date and Time',
                    labelStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: primaryColor,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
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
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the city name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: descriptionController,
                  minLines: 3,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    height: height * 0.06,
                    width: width - 40,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      onPressed: saveChanges,
                      child: const Text(
                        "Save Changes",
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
      ),
    );
  }
}
