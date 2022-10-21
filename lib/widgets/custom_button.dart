import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CustomButton extends StatelessWidget {
  final bool enable;
  final VoidCallback onPressed;
  final String buttonText;
  final RoundedLoadingButtonController btnController;

  const CustomButton(
      {Key key,
      this.onPressed,
      this.enable,
      this.btnController,
      this.buttonText = "Continue   >"})
      : super(key: key);

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

class CustomButton2 extends StatelessWidget {
  final bool enable;
  final VoidCallback onPressed;
  final String buttonText;
  final RoundedLoadingButtonController btnController;

  const CustomButton2(
      {Key key,
        this.onPressed,
        this.enable,
        this.btnController,
        this.buttonText = "Continue   >"})
      : super(key: key);

  void resetLoader() async {
    btnController.reset();
  }

  void stopLoader() async {
    btnController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return  enable?InkWell(
      onTap: enable?onPressed:null,
      child: Material(
        elevation: enable?2:0,
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(35)),
        child: Container(
          height: 50,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(35)),
            color: enable?Colors.blue:Colors.grey,
          ),

          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),

        ),
      ),
    ):Container();
  }
}
