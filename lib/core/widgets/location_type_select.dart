import 'package:flutter/material.dart';
import 'package:travel_point/core/type/type_def.dart';

class LocationTypeSelectionDialog extends StatefulWidget {
  final Function(List<PlaceType> selectedTypes) onTypesSelected;

  const LocationTypeSelectionDialog({super.key, required this.onTypesSelected});

  @override
  _LocationTypeSelectionDialogState createState() =>
      _LocationTypeSelectionDialogState();
}

class _LocationTypeSelectionDialogState
    extends State<LocationTypeSelectionDialog> {
  final List<PlaceType> _selectedTypes = [];
  String _searchQuery = "";
  bool _isOKButtonEnabled = false;

  String formatLocationTypeName(String name) {
    // Split the name by underscores
    final parts = name.split('_');

    // Capitalize the first letter of each word and join them with spaces
    final formattedName = parts.map((part) {
      return part.substring(0, 1).toUpperCase() + part.substring(1);
    }).join(' ');

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

  void _clearAll() {
    setState(() {
      _selectedTypes.clear();
      _updateOKButtonState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return AlertDialog(
      title: const Padding(
        padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 0),
        child: Text("Select Location Types", style: TextStyle(fontSize: 18),),
      ),
      contentPadding: const EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                        _updateOKButtonState(); // Update the button state
                      });
                    },
                    activeColor: primaryColor,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          // Clear All button
          onPressed: () {
            _clearAll();
          },
          child: const Text("Clear All"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _isOKButtonEnabled
              ? () {
                  widget.onTypesSelected(_selectedTypes);
                  Navigator.of(context).pop();
                }
              : null, // Disable the button if no checkboxes are selected
          child: Text(
            "OK",
            style: TextStyle(
              color: _isOKButtonEnabled ? primaryColor : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
