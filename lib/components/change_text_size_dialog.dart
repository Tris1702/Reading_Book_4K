import 'package:flutter/material.dart';
import 'package:reading_book_4k/assets/app_dimen.dart';
import 'package:reading_book_4k/assets/app_string.dart';

class ChangeTextSizeDialog extends StatefulWidget {
  final ValueSetter<String> callback;
  final double currentSize;
  const ChangeTextSizeDialog(
      {Key? key, required this.callback, required this.currentSize})
      : super(key: key);

  @override
  State<ChangeTextSizeDialog> createState() => _ChangeTextSizeDialogState();
}

class _ChangeTextSizeDialogState extends State<ChangeTextSizeDialog> {
  @override
  Widget build(BuildContext context) {
    List<String> size = [AppString.smallest, AppString.small, AppString.medium, AppString.large, AppString.largest];
    String _selected = size[4];
    if (widget.currentSize - AppDimen.textSizeSubtext < 0.001) {
      _selected = size[0];
    } else if (widget.currentSize - AppDimen.textSizeBody3 < 0.001) {
      _selected = size[1];
    } else if (widget.currentSize - AppDimen.textSizeBody2 < 0.001) {
      _selected = size[2];
    } else if (widget.currentSize - AppDimen.textSizeBody1 < 0.001) {
      _selected = size[3];
    }

    return AlertDialog(
      title: const Text(AppString.textSize),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) => RadioListTile(
            title: Text(size[index]),
            onChanged: (value) {
              widget.callback(value as String);
              setState(() {
                _selected = value;
              });
            },
            value: size[index],
            groupValue: _selected,
          ),
        ),
      ),
    );
  }
}
