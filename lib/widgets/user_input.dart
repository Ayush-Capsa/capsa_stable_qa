import 'package:capsa/anchor/Invoice/invoices.dart';
import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:flutter/services.dart';

class UserTextFormField extends StatelessWidget {
  final String label;
  final bool isMobile;
  final dynamic textFormField;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String Function(String) validator;
  final onChanged;
  final onSaved;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final dynamic minLines;
  final dynamic maxLines;
  final dynamic inputFormatters;
  final onTap;
  final onActionTap;
  final bool readOnly;
  final String hintText;
  final String errorText;
  final EdgeInsetsGeometry padding;
  final Widget prefixIcon;
  final String action;
  final String note;
  final String info;
  final bool showBorder;
  final bool expand;
  final double inputFieldHeight;
  final double fontSize;

  final Widget suffixIcon;

  final autovalidateMode;

  final obscureText;
  final fillColor;
  final int maxLength;
  final maxLengthEnforcement;
  final double borderRadius;

  // final  Widget pre ;

  UserTextFormField({
    @required this.label,
    this.isMobile = false,
    this.textFormField,
    this.padding,
    this.controller,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.onTap,
    this.onActionTap,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.minLines = 1,
    this.maxLines: 1,
    this.inputFormatters,
    this.hintText: '',
    this.errorText: '',
    this.prefixIcon,
    this.maxLength,
    this.focusNode,
    this.suffixIcon,
    this.maxLengthEnforcement,
    this.autovalidateMode,
    this.fillColor: Colors.white,
    this.action: '',
    this.obscureText: false,
    this.note = "",
    this.showBorder = false,
    this.expand = false,
    this.inputFieldHeight = 20,
    this.borderRadius,
    this.fontSize,
    this.info,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _focusNode = focusNode;
    if (focusNode == null) _focusNode = new FocusNode();

    var _validator = validator;
    if (validator == null) {
      _validator = (String v) {
        if (v.isEmpty) {
          return "This field is required.";
        }
        return null;
      };
    }

    return Container(
      padding: padding != null ? padding : EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisSize: MainAxisSize.min,
        children: [
          if (label != '')
            InkWell(
              onTap: () => _focusNode.requestFocus(),
              child: Text(
                label,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 14,
                    letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ),
          SizedBox(
            height: 10,
          ),
          (textFormField != null)
              ? textFormField
              : Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color:
                    showBorder ? Colors.black : Colors.transparent)),
            height: expand ? inputFieldHeight : null,
            child: TextFormField(
              expands: expand,
              inputFormatters: (inputFormatters != null)
                  ? inputFormatters
                  : <TextInputFormatter>[],
              controller: controller,
              validator: _validator,
              focusNode: _focusNode,
              keyboardType: keyboardType,
              onTap: onTap,
              minLines: expand ? null : minLines,
              maxLength: maxLength,
              maxLines: expand ? null : maxLines,
              readOnly: readOnly,
              onChanged: onChanged,
              obscureText: obscureText,
              onSaved: onSaved,
              maxLengthEnforcement: maxLengthEnforcement,
              textInputAction: textInputAction,
              autovalidateMode: autovalidateMode,
              style: TextStyle(
                  fontSize: fontSize == null
                      ? isMobile
                      ? 14
                      : 16.0
                      : fontSize,
                  color: Color(0xff525252)),
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: suffixIcon,

                prefixIcon: prefixIcon,
                filled: true,
                fillColor: fillColor,
                //errorText : errorText,
                hintText: hintText,
                hintStyle: TextStyle(
                    color: Color.fromRGBO(130, 130, 130, 1),
                    fontSize: fontSize == null ? 15 : fontSize,
                    letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1.2),
                contentPadding: EdgeInsets.only(
                    left: isMobile ? 4.0 : 8.0,
                    bottom: isMobile ? 6.0 : 12.0,
                    top: isMobile ? 6.0 : 12.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: fillColor),
                  borderRadius:
                  BorderRadius.circular(borderRadius ?? 15.7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: fillColor),
                  borderRadius:
                  BorderRadius.circular(borderRadius ?? 15.7),
                ),
              ),
            ),
          ),
          errorText != ''
              ? SizedBox(
            height: 5,
          )
              : SizedBox(
            height: 0,
          ),
          errorText != ''
              ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                errorText,
                style: TextStyle(
                    color: Colors.red, fontSize: isMobile ? 10 : 18),
              ),
              InkWell(
                  onTap: onActionTap,
                  child: Text(
                    action,
                    style: TextStyle(
                        color: Colors.blue, fontSize: isMobile ? 10 : 22),
                  )),
            ],
          )
              : Container(),
          note != ""
              ? SizedBox(
            height: 5,
          )
              : Container(),
          note != ""
              ? Row(mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start
              , children: [
            Text(
              'Note: ',
              style: TextStyle(
                  color: Colors.red, fontSize: isMobile ? 10 : 14),
            ),
            Container(

              child: Text(
                note,
                style: TextStyle(
                    color: Colors.black, fontSize: isMobile ? 10 : 14),
              ),
            ),
          ])
              : Container(),
          (info != "" && info != null)
              ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(
              info,
              style: TextStyle(
                  color: Colors.black, fontSize: !Responsive.isMobile(context) ? 18 : 8),
            ),
          ])
              : Container(),
        ],
      ),
    );
  }
}
