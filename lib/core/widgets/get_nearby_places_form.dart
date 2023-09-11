import 'package:flutter/material.dart';
import 'package:travel_point/core/type/type_def.dart';

class NearbyPlacesFormDialog extends StatefulWidget {
  final Function(List<PlaceType> selectedTypes, double? radius) onTypesSelected;

  const NearbyPlacesFormDialog({
    Key? key,
    required this.onTypesSelected,
  }) : super(key: key);

  @override
  _NearbyPlacesFormDialogState createState() => _NearbyPlacesFormDialogState();
}

class _NearbyPlacesFormDialogState extends State<NearbyPlacesFormDialog> {
  int _currentStep = 0;
  final List<PlaceType> _selectedTypes = [];
  String _searchQuery = "";
  bool _isOKButtonEnabled = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Add form key
  final TextEditingController _radiusController = TextEditingController();
  double? _radius;

  String formatLocationTypeName(String name) {
    final parts = name.split('_');
    final formattedName = parts
        .map((part) => part.substring(0, 1).toUpperCase() + part.substring(1))
        .join(' ');
    return formattedName;
  }

  List<PlaceType> getFilteredTypes() {
    return PlaceType.values.where((type) {
      final typeName = formatLocationTypeName(type.name);
      return typeName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _updateOKButtonState() {
    setState(() {
      _isOKButtonEnabled = _selectedTypes.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        title: const Text('Select place type: '),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search..',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            SizedBox(
                height: 300.0,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: getFilteredTypes().map((type) {
                            return CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(formatLocationTypeName(type.name)),
                              value: _selectedTypes.contains(type),
                              onChanged: (selected) {
                                setState(() {
                                  if (selected!) {
                                    _selectedTypes.add(type);
                                  } else {
                                    _selectedTypes.remove(type);
                                  }
                                  _updateOKButtonState();
                                });
                              },
                              activeColor: Theme.of(context).primaryColor,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
        isActive: true,
      ),
      Step(
        title: const Text('Enter distance radius: '),
        content: Form(
          key: _formKey, // Assign the form key
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter Radius:'),
              Padding(
                padding: const EdgeInsets.only(top: 15.0), // Add bottom padding
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText:
                        'Distance in meters..', // Your placeholder text here
                  ),
                  controller: _radiusController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _radius = double.tryParse(value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a radius value.';
                    }
                    if (_radius == null) {
                      return 'Invalid radius value.';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode
                      .onUserInteraction, // Autovalidate on user interaction
                ),
              ),
            ],
          ),
        ),
        isActive:
            _currentStep == 1, // Make this step active only when it's reached
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Nearby Places'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
          });
        },
        onStepContinue: () {
          if (_currentStep == 0) {
            // Check if Step 1 is completed (at least one place type selected)
            if (!_isOKButtonEnabled) {
              // Handle the case when the "Continue" button is pressed on Step 1 without selecting any place types.
              // You can display an error message or take any other action.
            } else {
              setState(() {
                _currentStep++;
              });
            }
          } else if (_currentStep == 1) {
            // Check if the form is valid (including radius validation)
            if (_formKey.currentState!.validate()) {
              // Call the callback to send back the data to the parent widget.
              widget.onTypesSelected(_selectedTypes, _radius);
            }
          }
        },
        onStepCancel: () {
          if (_currentStep == 0) {
            Navigator.of(context).pop();
          } else {
            setState(() {
              if (_currentStep > 0) {
                _currentStep--;
              }
            });
          }
        },
        steps: steps,
      ),
    );
  }
}
