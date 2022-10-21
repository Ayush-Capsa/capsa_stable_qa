import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class TabularView extends StatelessWidget {
  const TabularView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    double headerSize = 24;
    double itemSize = 26;
    double iconSize = 35;
    double textPadding = 16;

    return Padding(
      padding: const EdgeInsets.all(.0),
      child: Row(
        children: [
          Expanded(
            child: DataTable(
              columnSpacing: 102,
                dataRowHeight: 64,
                headingRowHeight: 64,
                columns: [
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Text('Factor',style: TextStyle(fontStyle: FontStyle.italic,fontSize: headerSize),),
                    ),
                  ),
                  DataColumn(
                    label:  Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Text('Score',style: TextStyle(fontStyle: FontStyle.italic,fontSize: headerSize),),
                    ),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Text('Details',style: TextStyle(fontStyle: FontStyle.italic,fontSize: headerSize),),
                    ),
                  ),
                ],
                rows: [

                  DataRow(cells: [
                    DataCell(Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Text('Buisness Growth',style: TextStyle(fontWeight: FontWeight.bold,fontSize: itemSize),),
                    ),),
                    DataCell(Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Icon(Icons.check,color: Colors.green,size: iconSize,),
                    ),),
                    DataCell(Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Text('Consistent Growth in Sales',style: TextStyle(fontSize: itemSize),),
                    ),),
                  ]),
                  DataRow(cells: [
                    DataCell(Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Text('Buisness Growth',style: TextStyle(fontWeight: FontWeight.bold,fontSize: itemSize),),
                    ),),
                    DataCell(Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Icon(Icons.check,color: Colors.green,size: iconSize,),
                    ),),
                    DataCell(Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Text('Consistent Growth in Sales',style: TextStyle(fontSize: itemSize),),
                    ),),
                  ]),
                  DataRow(cells: [
                    DataCell(Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Text('Buisness Growth',style: TextStyle(fontWeight: FontWeight.bold,fontSize: itemSize),),
                    ),),
                    DataCell(Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Icon(Icons.check,color: Colors.green,size: iconSize,),
                    ),),
                    DataCell(Padding(
                      padding: EdgeInsets.all(textPadding),
                      child: Text('Consistent Growth in Sales',style: TextStyle(fontSize: itemSize),),
                    ),),
                  ]),
                ]),
          ),
        ],
      ),
    );
    
    // return Padding(
    //   padding: const EdgeInsets.all(12.0),
    //   child: Transform.scale(
    //     scale: 0.9,
    //     child: Container(
    //       height: MediaQuery.of(context).size.height * 0.8,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: [
    //
    //           Expanded(
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Text('Factor',style: TextStyle(fontStyle: FontStyle.italic,fontSize: headerSize),),
    //                 Text('Score',style: TextStyle(fontStyle: FontStyle.italic,fontSize: headerSize),),
    //                 Text('Details',style: TextStyle(fontStyle: FontStyle.italic,fontSize: headerSize),),
    //               ],
    //             )
    //           ),
    //
    //           Expanded(
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Text('Buisness Growth',style: TextStyle(fontWeight: FontWeight.bold,fontSize: itemSize),),
    //                 Icon(Icons.check,color: Colors.green,size: iconSize,),
    //                 Text('Consistent Growth in Sales',style: TextStyle(fontSize: itemSize),),
    //                 // Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //                 // Text('Buisness Growth',style: TextStyle(fontWeight: FontWeight.bold,fontSize: itemSize),),
    //                 // Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //                 // Text('Buisness Growth',style: TextStyle(fontWeight: FontWeight.bold,fontSize: itemSize),),
    //                 // Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //                 // Text('Buisness Growth',style: TextStyle(fontWeight: FontWeight.bold,fontSize: itemSize),),
    //                 // Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //                 // Text('Buisness Growth',style: TextStyle(fontWeight: FontWeight.bold,fontSize: itemSize),),
    //                 // Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //                 // Text('Buisness Growth',style: TextStyle(fontWeight: FontWeight.bold,fontSize: itemSize),),
    //               ],
    //             ),
    //           ),
    //           Expanded(
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: [
    //                 Text('Buisness Growth',style: TextStyle(fontWeight: FontWeight.bold,fontSize: itemSize),),
    //                 Icon(Icons.check,color: Colors.green,size: iconSize,),
    //                 Text('Consistent Growth in Sales',style: TextStyle(fontSize: itemSize),),
    //               ],
    //             ),
    //           ),
    //           // Expanded(
    //           //   child: Row(
    //           //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           //     children: [
    //           //       Text('Score',style: TextStyle(fontStyle: FontStyle.italic,fontSize: headerSize),),
    //           //       Container(height: 1,color: Colors.black,),
    //           //       Icon(Icons.check,color: Colors.green,size: iconSize,),
    //           //       Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //           //       Icon(Icons.check,color: Colors.green,size: iconSize,),
    //           //       Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //           //       Icon(Icons.check,color: Colors.green,size: iconSize,),
    //           //       Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //           //       Icon(Icons.check,color: Colors.green,size: iconSize),
    //           //       Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //           //       Icon(Icons.check,color: Colors.green,size: iconSize,),
    //           //       Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //           //       Icon(Icons.check,color: Colors.green,size: iconSize,),
    //           //       Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //           //       Icon(Icons.check,color: Colors.green,size: iconSize,),
    //           //     ],
    //           //   ),
    //           // ),
    //           Expanded(
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: [
    //                 Text('Buisness Growth',style: TextStyle(fontWeight: FontWeight.bold,fontSize: itemSize),),
    //                 Icon(Icons.check,color: Colors.green,size: iconSize,),
    //                 Text('Consistent Growth in Sales',style: TextStyle(fontSize: itemSize),),
    //               ],
    //             ),
    //           ),
    //           // Expanded(
    //           //   child: Row(
    //           //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           //       children:[
    //           //       Text('Details',style: TextStyle(fontStyle: FontStyle.italic,fontSize: headerSize),),
    //           //       Container(height: 1,color: Colors.black,),
    //           //       Text('Consistent Growth in Sales',style: TextStyle(fontSize: itemSize),),
    //           //       Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //           //       Text('Consistent Growth in Sales',style: TextStyle(fontSize: itemSize),),
    //           //       Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //           //       Text('Consistent Growth in Sales',style: TextStyle(fontSize: itemSize),),
    //           //       Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //           //       Text('Consistent Growth in Sales',style: TextStyle(fontSize: itemSize),),
    //           //       Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //           //       Text('Consistent Growth in Sales',style: TextStyle(fontSize: itemSize),),
    //           //       Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //           //       Text('Consistent Growth in Sales',style: TextStyle(fontSize: itemSize),),
    //           //       Container(height: 1,color: Colors.black.withOpacity(0.5),),
    //           //       Text('Consistent Growth in Sales',style: TextStyle(fontSize: itemSize),),
    //           //     ],
    //           //   ),
    //           // ),
    //
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
