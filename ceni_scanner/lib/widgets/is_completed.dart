import 'package:ceni_scanner/helpers/localization.dart';
import 'package:flutter/material.dart';

class IsCompletedWidget extends StatefulWidget {
  final bool isComplete;
  final int numberValue;
  final ValueChanged<int> onNumberChanged;
  final ValueChanged<bool?> onChanged;

  const IsCompletedWidget({
    Key? key,
    required this.isComplete,
    required this.numberValue,
    required this.onNumberChanged,
    required this.onChanged,
  }) : super(key: key);

  @override
  _IsCompletedWidgetState createState() => _IsCompletedWidgetState();
}

class _IsCompletedWidgetState extends State<IsCompletedWidget> {
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _isComplete = widget.isComplete;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(ApplicationLocalization.translator.isComplete),
      value: _isComplete,
      onChanged: (newValue) {
        setState(() {
          _isComplete = newValue ?? false;
          if (_isComplete) {
            widget.onNumberChanged(widget.numberValue);
          }
          widget.onChanged(_isComplete);
        });
      },
    );
  }
}
