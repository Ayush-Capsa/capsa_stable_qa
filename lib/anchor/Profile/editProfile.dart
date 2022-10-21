import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class editProfile extends StatefulWidget {
  const editProfile({Key key}) : super(key: key);

  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: double.infinity,
            width: MediaQuery.of(context).size.width*0.13,
            color: Color.fromRGBO(16, 16, 16, 1),
            child: Card(
            ),
          )
        ],
      ),
    );
  }
}
