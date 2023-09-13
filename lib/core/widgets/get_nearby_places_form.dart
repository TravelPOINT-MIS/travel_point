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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
            if (!_isOKButtonEnabled) {
            } else {
              setState(() {
                _currentStep++;
              });
            }
          } else if (_currentStep == 1) {
            if (_formKey.currentState!.validate() && _isOKButtonEnabled) {
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
        steps: [
          Step(
            title: const Text('Select place type: '),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                  child: ListView(
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
              ],
            ),
            isActive: true,
          ),
          Step(
            title: const Text('Enter distance radius: '),
            content: Builder(
              builder: (BuildContext formContext) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Enter Radius:'),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Distance in meters..',
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
                            double? enteredValue = double.tryParse(value);
                            if (enteredValue == null) {
                              return 'Invalid radius value.';
                            }
                            if (enteredValue > 50000) {
                              return 'Value must be less than or equal to 50,000.';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            isActive: _selectedTypes
                .isNotEmpty, // Step 2 is active only if place types are selected
          ),
        ],
      ),
    );
  }
}
