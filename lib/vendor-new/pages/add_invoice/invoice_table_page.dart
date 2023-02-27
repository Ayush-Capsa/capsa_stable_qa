import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InvoiceTable extends StatefulWidget {
  const InvoiceTable({Key key}) : super(key: key);

  @override
  State<InvoiceTable> createState() => _InvoiceTableState();
}

class _InvoiceTableState extends State<InvoiceTable> {

  List<TableRow> rows = [];
  bool dataLoaded = false;
  String search = "";

  List<bool> expand = [false,false,false,false,false];

  void getData(){
    rows = [];
    rows.add(
        TableRow(children: [
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(' ', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('S/N', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('Invoice No', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('Issue Date', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('Due Date', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('Anchor', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('Invoice Amount (₦)', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('Status', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(' ', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          )
        ])
    );

    for(int i = 0;i<5;i++){

      rows.add(
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: InkWell(
                onTap: (){
                  setState(() {
                    expand[i] = !expand[i];
                    getData();

                  });
                },
                child: expand[i]?Icon(Icons.arrow_drop_down_sharp):Icon(Icons.arrow_right_sharp),
              )


            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text((i+1).toString(), style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text('IN0000001', style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text("23 July, 2021", style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text("23 December, 2021", style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text("Stanbic IBTC Bank Plc", style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text('12,00,00', style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
            ),

            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text("Pending", style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: HexColor('#F2994A'),
              )),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 16,top: 8),
                child: PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        child: InkWell(
                          onTap: () {
                            // capsaPrint('view Tapped');
                            setState(() {
                              // dialogHelper.showPdf(context,anchorsActions, _acctTable[i].fileName);
                            });
                          },
                          child: Row(
                            children: [
                              Icon(Icons.remove_red_eye),
                              RichText(
                                text: TextSpan(
                                  text: 'View Invoice',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(51, 51, 51, 1)),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ],
                )
            )
          ])
      );

      if(expand[i]){
        for(int j = 0;j<3;j++){
          rows.add(
              TableRow(children: [
                Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(''),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text('${i + 1}.${j+1}', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text('IN0000001', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text("23 July, 2021", style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text("23 December, 2021", style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text("Stanbic IBTC Bank Plc", style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text('12,00,00', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  )),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text("Pending", style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: HexColor('#F2994A'),
                  )),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 16,top: 8),
                    child: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            child: InkWell(
                              onTap: () {
                                // capsaPrint('view Tapped');
                                setState(() {
                                  // dialogHelper.showPdf(context,anchorsActions, _acctTable[i].fileName);
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.remove_red_eye),
                                  RichText(
                                    text: TextSpan(
                                      text: 'View Invoice',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(51, 51, 51, 1)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ),
                      ],
                    )
                )
              ])
          );
        }
      }

    }
    setState(() {
      dataLoaded = true;
    });

  }

  @override
  void initState(){
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: dataLoaded?Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 22,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(29, 0, 36, 0),
                child: TopBarWidget("Add Invoice", ""),
              ),
              SizedBox(
                height: (!Responsive.isMobile(context)) ? 8 : 15,
              ),
              Container(
                // padding: EdgeInsets.all((!Responsive.isMobile(context)) ? 12 : 1.0),
                // color: Colors.white,
                //width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(29, 24, 36, 0),
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        // width: 200,
                        height: (!Responsive.isMobile(context)) ? 65 : 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Colors.white,
                        ),
                        padding: Responsive.isMobile(context)
                            ? EdgeInsets.symmetric(horizontal: 5, vertical: 2)
                            : EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Center(
                          child: TextFormField(
                            // autofocus: false,
                            onChanged: (v) {
                              search = v;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // fillColor: Color.fromRGBO(234, 233, 233, 1.0),
                              // filled: true,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,

                              // contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.search),
                              ),
                              // isDense: true,
                              // focusedBorder: InputBorder.none,
                              // enabledBorder: InputBorder.none,
                              // errorBorder: InputBorder.none,
                              // disabledBorder: InputBorder.none,
                              // contentPadding: EdgeInsets.only(left: 15, bottom: 15, top: 15, right: 15),
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(130, 130, 130, 1),
                                  fontFamily: 'Poppins',
                                  fontSize: (!Responsive.isMobile(context)) ? 18 : 15,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                              hintText: Responsive.isMobile(context) ? "Search by invoice number" : "Search by invoice number, Anchor name",
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 40,),
                    Container(
                      width: 200,
                      height: 59,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: HexColor('#0098DB'),
                      ),
                      child: Center(
                        child: Text(
                          'Add Invoice',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(29, 24, 36, 33),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(

                        columnWidths: {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1.2),
                          2: FlexColumnWidth(2.4),
                          3: FlexColumnWidth(2.8),
                          4: FlexColumnWidth(3.2),
                          5: FlexColumnWidth(3.0),
                          6: FlexColumnWidth(2.8),
                          7: FlexColumnWidth(2.4),
                          8: FlexColumnWidth(0.9),

                        },
                        border: TableBorder(verticalInside: BorderSide.none),
                        children: rows,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(900, 10, 15, 16),
                      child: Card(
                        color: Color.fromRGBO(245, 251, 255, 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          width: 290,
                          height: 56,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 17.5, 24, 17.5),
                                child: Text(
                                  'Page',
                                  style: TextStyle(fontSize: 14, color: Color.fromRGBO(51, 51, 51, 1)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 17.5, 30, 17.5),
                                child: Text(
                                  '1 of 1',
                                  style: TextStyle(fontSize: 14, color: Color.fromRGBO(51, 51, 51, 1)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 22, 30, 22),
                                child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios), iconSize: 14, color: Color.fromRGBO(130, 130, 130, 1), padding: EdgeInsets.all(0)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 22, 14, 22),
                                child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios), iconSize: 14, color: Color.fromRGBO(130, 130, 130, 1), padding: EdgeInsets.all(0)),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}
