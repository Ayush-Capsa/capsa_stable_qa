import 'package:capsa/functions/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoBox extends StatelessWidget {
  String header;
  String content;
  double width;
  InfoBox({Key key, @required this.header, @required this.content, this.width = 292})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:12,bottom: 6,top: 6),
      child: Container(
        width: width,
        height: 107,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: IntrinsicWidth(
                child: Container(
                    height: 40,
                    //width: 126,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: HexColor('#F5FBFF'),
                    ),
                    child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8,right: 8),
                          child: Text(
                      header,
                      style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w400,color: HexColor('#0098DB'),),
                    ),
                        ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12,top: 12),
              child: Text(content,
              style: GoogleFonts.poppins(
                     fontSize: 18, fontWeight: FontWeight.w400,color: Colors.black,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
