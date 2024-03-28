import 'package:aws_flutter/app/app.logger.dart';
import 'package:aws_flutter/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:vertical_percent_indicator/vertical_percent_indicator.dart';

class ButtonContainer extends StatelessWidget {
  final void Function() ontap;
  final bool isDisable;
  final String name;
  final String image;
  final int value;
  // final void Function()? onAutoTap;
  const ButtonContainer({
    super.key,
    required this.ontap,
    required this.name,
    required this.image,
    //this.onAutoTap,
    required this.isDisable,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final log = getLogger('Button Container');
    double _dobval = value / 10;

    log.v(_dobval);
    return Column(
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 25),
        ),
        verticalSpaceSmall,
        InkResponse(
          onTap: ontap,
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black)),
              height: 100,
              width: 100,
              // color: Color.fromARGB(255, 129, 92, 92),
              child: Center(
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              )),
        ),
        VerticalBarIndicator(
          animationDuration: const Duration(seconds: 2),
          percent: _dobval,
          height: 150,
          width: 30,
          color: const [
            Color.fromARGB(255, 241, 3, 3),
            Color.fromARGB(255, 232, 109, 8),
          ],
          header: '${value * 10}%',
          footer: name,
        )
        // FAProgressBar(
        //   direction: Axis.vertical,
        //   backgroundColor: Colors.blue,
        //   changeProgressColor: Colors.white,
        //   currentValue: 60,
        // )
      ],
    );
  }
}
