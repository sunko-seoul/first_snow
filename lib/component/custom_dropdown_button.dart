import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  List<String> reasonList;

  CustomDropdownButton({
    required this.reasonList,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDropdownButton> createState() =>
      _CustomStateDropdownButtonState();
}

class _CustomStateDropdownButtonState extends State<CustomDropdownButton> {
  late String _selectedReason;

  @override
  void initState() {
    _selectedReason = widget.reasonList.isEmpty ? '' : widget.reasonList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<String>(
            value: _selectedReason,
            isExpanded: true,
            items:
                widget.reasonList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedReason = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }
}
