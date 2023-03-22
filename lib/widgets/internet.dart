import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class InternetNotWorking extends StatelessWidget {
  const InternetNotWorking({super.key, required this.T});
  final String T;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
          child: Container(
        child: Text("Internet not available $T"),
      )),
    );
    ;
  }
}
