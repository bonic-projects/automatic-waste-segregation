import 'package:aws_flutter/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

class ButtonContainer extends StatelessWidget {
  final void Function() ontap;
  final bool isDisable;
  final String name;
  final String image;
  // final void Function()? onAutoTap;
  const ButtonContainer({
    super.key,
    required this.ontap,
    required this.name,
    required this.image,
    //this.onAutoTap,
    required this.isDisable,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: ontap,
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 25),
          ),
          verticalSpaceSmall,
          Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black)),
              height: 120,
              width: 120,
              // color: Color.fromARGB(255, 129, 92, 92),
              child: Center(
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              )),
        ],
      ),
    );
  }
}
