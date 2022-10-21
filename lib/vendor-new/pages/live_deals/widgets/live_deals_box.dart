import 'package:capsa/functions/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveDealsBox extends StatefulWidget {
  const LiveDealsBox({Key key}) : super(key: key);

  @override
  State<LiveDealsBox> createState() => _LiveDealsBoxState();
}

class _LiveDealsBoxState extends State<LiveDealsBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      height: 405,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 10,
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              color: HexColor('#EB5757'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(26,14,26,14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(58, 192, 201, 1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Image.asset('assets/company_icon.png',
                          width: 30, height: 27)),
                ),
                Container(
                  width: 89,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: HexColor('#3AC0C9').withOpacity(0.2),
                  ),
                  child: Center(
                    child: Text(
                      'Anchor',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: HexColor('#3AC0C9')),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
