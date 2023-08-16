import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputField extends StatelessWidget {
  final TextEditingController? controller;
  final bool isFirst;
  final bool isLast;
  final bool isCorrect;
  const OtpInputField({
    super.key,
    this.controller,
    this.isFirst = false,
    this.isLast = false,
    this.isCorrect = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) {
        if (value.isNotEmpty && isLast == false) {
          FocusScope.of(context).nextFocus();
        } else if (value.isNotEmpty && isFirst == false) {
          FocusScope.of(context).previousFocus();
        }
      },
      style: const TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
      ),
      showCursor: false,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
      ],
      decoration: InputDecoration(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width / 7,
          maxHeight: MediaQuery.of(context).size.width / 7,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isCorrect ? Colors.green : Colors.grey,
            width: 2.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isCorrect ? Colors.green : Colors.grey,
            width: 2.5,
          ),
        ),
      ),
    );
  }
}
