import 'package:aws_flutter/ui/common/ui_helpers.dart';
import 'package:aws_flutter/ui/smart_widgets/online_status.dart';
import 'package:aws_flutter/ui/views/home/Widgets/auto_Switch.dart';
import 'package:aws_flutter/ui/views/home/Widgets/button_Container.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        appBar: AppBar(
          actions: const [
            Row(
              children: [IsOnlineWidget(), horizontalSpaceSmall],
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Automatic',
                      style: TextStyle(color: Colors.black),
                    ),
                    horizontalSpaceTiny,
                    AutoSwitch(
                      isAuto: viewModel.isAuto,
                      onClick: viewModel.autoButton,
                    )
                  ],
                ),
                ButtonContainer(
                  ontap: () => viewModel.isAuto
                      ? viewModel.showBottomSheet()
                      : viewModel.isBinMovement('d'),

                  //viewModel.isBinMovement('d'),
                  image: 'assets/images/dry.png',
                  name: 'Dry',
                  isDisable: viewModel.isAuto,
                ),
                verticalSpaceMedium,
                ButtonContainer(
                  ontap: () => viewModel.isAuto
                      ? viewModel.showBottomSheet()
                      : viewModel.isBinMovement('w'),
                  image: 'assets/images/humidity.png',
                  name: 'Wet',
                  isDisable: viewModel.isAuto,
                ),
                verticalSpaceMedium,
                ButtonContainer(
                  ontap: () => viewModel.isAuto
                      ? viewModel.showBottomSheet()
                      : viewModel.isBinMovement('m'),
                  image: 'assets/images/metal.png',
                  name: 'Metal',
                  isDisable: viewModel.isAuto,
                ),
              ],
            ),
          ),
        ));
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.onModelReady();
    super.onViewModelReady(viewModel);
  }
}
