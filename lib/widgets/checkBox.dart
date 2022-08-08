import 'package:flutter/material.dart';

class MyCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color checkedIconColor;
  final Color checkedFillColor;
  final IconData checkedIcon;

  const MyCheckbox({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.checkedIconColor = Colors.white,
    this.checkedFillColor = Colors.orange,
    this.checkedIcon = Icons.check,
  }) : super(key: key);

  @override
  _MyCheckboxState createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  bool _checked;
  CheckStatus _status;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(MyCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  void _init() {
    _checked = widget.value;

    if (_checked == null) {
      _status = CheckStatus.empty;
    } else if (_checked) {
      _status = CheckStatus.checked;
    } else {
      _status = CheckStatus.empty;
    }
  }

  Widget _buildIcon() {
    Color fillColor;
    Color iconColor;
    IconData iconData;

    switch (_status) {
      case CheckStatus.empty:
        break;
      case CheckStatus.checked:
        fillColor = widget.checkedFillColor;
        iconColor = widget.checkedIconColor;
        iconData = widget.checkedIcon;
        break;
      case CheckStatus.empty2:
        break;
    }

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor,
        border: Border.all(color: Colors.grey[500], width: .5),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 15,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _buildIcon(),
      onPressed: () => widget.onChanged(_checked == null ? true : !_checked),
    );
  }
}

enum CheckStatus { empty, checked, empty2 }
