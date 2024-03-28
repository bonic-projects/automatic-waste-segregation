import 'package:aws_flutter/ui/common/ui_helpers.dart';
import 'package:aws_flutter/ui/smart_widgets/online_status.dart';
import 'package:aws_flutter/ui/views/home/Widgets/auto_Switch.dart';
import 'package:aws_flutter/ui/views/home/Widgets/button_Container.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      //onViewModelReady: (viewModel) => viewModel.onModelReady(),
      builder: (context, model, child) {
        return Scaffold(
            appBar: AppBar(
              actions: const [
                Row(
                  children: [IsOnlineWidget(), horizontalSpaceSmall],
                )
              ],
            ),
            body: model.node?.wet == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.blueGrey[600],
                      ),
                      verticalSpaceSmall,
                      Text(
                        "Fetching...",
                        style: TextStyle(fontSize: 24, color: Colors.blueGrey[700]),
                      )
                    ],
                  ))
                : Container(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // FAProgressBar(
                          //   currentValue: 70,
                          //   progressColor: Colors.blueAccent,
                          //   verticalDirection: VerticalDirection.up,
                          //   backgroundColor: Colors.black,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'Automatic',
                                style: TextStyle(color: Colors.black),
                              ),
                              horizontalSpaceTiny,
                              AutoSwitch(
                                isAuto: model.isAuto,
                                onClick: model.autoButton,
                              )
                            ],
                          ),
                          verticalSpaceLarge,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  ButtonContainer(
                                    value: model.node!.dry,
                                    ontap: () => model.isAuto
                                        ? model.showBottomSheet()
                                        : model.isBinMovement('d'),

                                    //model.isBinMovement('d'),
                                    image: 'assets/images/dry.png',
                                    name: 'Dry',
                                    isDisable: model.isAuto,
                                  ),
                                  // FAProgressBar(
                                  //   direction: Axis.vertical,
                                  //   size: 20,
                                  //   backgroundColor: Colors.blue,
                                  //   progressColor: Colors.yellow,
                                  //   currentValue: 60,
                                  // )
                                ],
                              ),
                              //  horizontalSpaceSmall,
                              Column(
                                children: [
                                  ButtonContainer(
                                    value: model.node!.wet,
                                    ontap: () => model.isAuto
                                        ? model.showBottomSheet()
                                        : model.isBinMovement('w'),
                                    image: 'assets/images/humidity.png',
                                    name: 'Wet',
                                    isDisable: model.isAuto,
                                  ),
                                  // FAProgressBar(
                                  //   direction: Axis.vertical,
                                  //   size: 20,
                                  //   backgroundColor: Colors.blue,
                                  //   progressColor: Colors.yellow,
                                  //   currentValue: 60,
                                  // )
                                ],
                              ),
                              //horizontalSpaceSmall,
                              Column(
                                children: [
                                  ButtonContainer(
                                    value: model.node!.metal,
                                    ontap: () => model.isAuto
                                        ? model.showBottomSheet()
                                        : model.isBinMovement('m'),
                                    image: 'assets/images/metal.png',
                                    name: 'Metal',
                                    isDisable: model.isAuto,
                                  ),
                                  //   FAProgressBar(
                                  //   direction: Axis.vertical,
                                  //   size: 20,
                                  //   backgroundColor: Colors.blue,
                                  //   progressColor: Colors.yellow,
                                  //   currentValue: 60,
                                  // )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ));
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
