import 'dart:convert';
import 'dart:io';

import 'package:discounttour/views/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/event.dart';
import '../../data/data.dart';

class EventCreateScreen extends StatefulWidget {
  static const routeName = '/event-create';

  @override
  _EventCreateScreenState createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  List<String> categories = getCategories();
  String _selectedCategory;

  String title;
  double rating;
  int noOfTours;
  String preViewImg;
  String description;
  String type;
  String subType;
  DateTime eventDate;
  String lat;
  String longitude;
  String url;
  String location;
  DateTime _selectedDate;

  List<String> assets = [];

  _validateAndSubmit() {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      var req = {
        'title': title,
        'rating': rating,
        'noOfTours': noOfTours,
        'preViewImg': preViewImg,
        'description': description,
        'type': type,
        'lat': lat,
        'longitudine': longitude,
        'url': url,
        'location': location,
        'assets': assets,
      };

      if (_selectedCategory == 'Evenimente') {
        req = {...req, 'eventDate': eventDate};
      }

      register(req);
    }
  }

  register(data) async {
    var res = await EventService().createEvent(data);

    if (res.toString() == 'CREATED') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Înregistrare finalizată ! '),
        ),
      );
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Home.routeName, (_) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Eroare de sistem !')));
    }
  }

  // Function to convert image to base64 string
  Future<String> _convertImageToBase64(String path) async {
    final bytes =
        await File(path).readAsBytes(); // Read bytes directly from file
    return base64Encode(bytes);
  }

  // Function to handle image selection for preview image
  Future<void> _pickPreviewImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image != null) {
      final base64String = await _convertImageToBase64(image.path);
      setState(() {
        preViewImg = base64String;
      });
    }
  }

  // Function to handle image selection for assets
  Future<void> _pickAssetImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image != null) {
      final base64String = await _convertImageToBase64(image.path);
      setState(() {
        assets.add(base64String);
      });
    }
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      final TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
      );
      if (selectedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    categories.remove('Toate');
    categories.add('Evenimente');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Creare",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xfffafafa),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24)),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Titlu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Titlul este obligatoriu';
                  }
                  return null;
                },
                onChanged: (value) {
                  title = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Descriere',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Descrierea este obligatorie';
                  }
                  return null;
                },
                onChanged: (value) {
                  description = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Locație',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Locația este obligatorie';
                  }
                  return null;
                },
                onChanged: (value) {
                  location = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Rating (0 - 5.0)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Introduceți valoarea';
                  }
                  final rating = double.tryParse(value);
                  if (rating == null) {
                    return 'Nu este număr';
                  }
                  if (rating < 0 || rating > 5.0) {
                    return 'Trebuie să fie cuprins între 0 și 5.0';
                  }
                  return null;
                },
                onChanged: (value) {
                  rating = double.parse(value);
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Vizite curente',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Introduceți număr de vizite curent';
                  }
                  final rating = double.tryParse(value);
                  if (rating == null) {
                    return 'Obligatoriu număr';
                  }
                  return null;
                },
                onChanged: (value) {
                  noOfTours = int.parse(value);
                },
              ),
              SizedBox(height: 20),
// Input for Type
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Tip activitate',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                value: type,
                onChanged: (value) {
                  setState(() {
                    type = value;
                    _selectedCategory = value;
                  });
                },
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Selectați tip activitate';
                  }
                  return null;
                },
              ),
              // SizedBox(height: 20),
              // TextFormField(
              //   decoration: InputDecoration(
              //     hintText: 'Subtype',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(40),
              //     ),
              //   ),
              //   validator: (value) {
              //     if (value.isEmpty) {
              //       return 'Please enter a subtype';
              //     }
              //     return null;
              //   },
              //   onSaved: (value) {
              //     subType = value;
              //   },
              // ),
// Input for Event Date
              Visibility(
                visible: _selectedCategory == 'Evenimente',
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          hintText: 'Event Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: Text(
                          _selectedDate != null
                              ? '${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year.toString()} ${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}'
                              : 'Select date',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Latitude',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter latitude';
                  }
                  return null;
                },
                onChanged: (value) {
                    lat = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Longitude',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter longitude';
                  }
                  return null;
                },
                onChanged: (value) {
                  longitude = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Site web url',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onChanged: (value) {
                  url = value;
                },
              ),
              SizedBox(height: 20),
// Input for Preview Image
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Imagine previzualizare:'),
                  ElevatedButton(
                    onPressed: _pickPreviewImage,
                    child: Text('Adaugă'),
                  ),
                ],
              ),
              Visibility(
                visible: preViewImg != null,
                child:
                    preViewImg != null ? _buildPreviewImageList() : SizedBox(),
              ),
              SizedBox(height: 20),
// Input for Assets
              Visibility(
                visible: _selectedCategory != "Evenimente",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Imagini adiționale:'),
                    ElevatedButton(
                      onPressed: _pickAssetImage,
                      child: Text('Adaugă'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
// Display added assets
              Visibility(
                visible: assets.isNotEmpty,
                child: _buildImageList(),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          _validateAndSubmit();
        },
        child: Icon(Icons.save, color: Colors.black),
      ),
    );
  }

  Widget _buildPreviewImageList() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.memory(
                    base64Decode(preViewImg),
                    height: 220,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  preViewImg = null;
                });
              },
            ),
          ],
        ),
      )
    ]);
  }

  Widget _buildImageList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: assets.map((String image) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(
                      base64Decode(image),
                      height: 220,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    assets.remove(image);
                  });
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
