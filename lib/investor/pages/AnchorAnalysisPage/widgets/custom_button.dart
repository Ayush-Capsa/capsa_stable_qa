import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CustomButton extends StatelessWidget {
  final bool enable;
  final VoidCallback onPressed;
  final String buttonText;


  CustomButton(
      {
      @required this.onPressed,
      @required this.enable,
      this.buttonText = "Continue   >"});

  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  void resetLoader() async {
    btnController.reset();
  }

  void stopLoader() async {
    btnController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      controller: btnController,
      height: 60,
      
      onPressed: onPressed,
      color: Theme.of(context).primaryColor,
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
