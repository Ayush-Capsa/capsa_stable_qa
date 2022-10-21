
import 'package:capsa/admin/data/buyer_vendor_list_data.dart';
import 'package:capsa/admin/providers/edit_table_data_provider.dart';
import 'package:capsa/admin/providers/tabbar_model.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class EditDemoList extends StatefulWidget {
  BuyerVendorListData data;
  int index;

  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditDemoList> {
  @override
  Widget build(BuildContext context) {
    final tab = Provider.of<TabBarModel>(context);
    widget.index = tab.editTabIndex;
    widget.data = tab.editTabData;
    final BuyerVendorListDataSource _historyDataSource =
        BuyerVendorListDataSource();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Edit Data',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: Container(
        padding: EdgeInsets.all(50),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {
                                widget.data.name = value;
                              },
                              initialValue: widget.data.name,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                helperText: '',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {
                                widget.data.bvnNo = value;
                              },
                              initialValue: widget.data.bvnNo,
                              decoration: InputDecoration(
                                labelText: 'BVN No',
                                helperText: '',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {
                                widget.data.phoneNo = value;
                              },
                              initialValue: widget.data.phoneNo,
                              decoration: InputDecoration(
                                labelText: 'Phone No',
                                helperText: '',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {
                                widget.data.email = value;
                              },
                              initialValue: widget.data.email,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                helperText: '',
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        onChanged: (value) {
                          widget.data.address = value;
                        },
                        initialValue: widget.data.address,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          helperText: '',
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          widget.data.city = value;
                        },
                        initialValue: widget.data.city,
                        decoration: InputDecoration(
                          labelText: 'City',
                          helperText: '',
                        ),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          widget.data.state = value;
                        },
                        initialValue: widget.data.state,
                        decoration: InputDecoration(
                          labelText: 'State',
                          helperText: '',
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          widget.data.action = value;
                        },
                        initialValue: widget.data.action,
                        decoration: InputDecoration(
                          labelText: 'Action',
                          helperText: '',
                        ),
                      ),
                      MediaQuery.of(context).size.width > 800
                          ? Container()
                          : Container(
                              margin: EdgeInsets.all(76),
                              color: Theme.of(context).accentColor,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: IconButton(
                                      color: Colors.black,
                                      icon: Icon(LineAwesomeIcons.remove),
                                      onPressed: () {},
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      margin: EdgeInsets.all(46),
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 50,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: MaterialButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22)),
                          onPressed: () {
                            BuyerVendorListData element = BuyerVendorListData(
                              widget.data.name,
                              widget.data.bvnNo,
                              widget.data.phoneNo,
                              widget.data.email,
                              widget.data.address,
                              widget.data.city,
                              widget.data.state,
                              widget.data.action,
                            );
                            setState(() {
                              _historyDataSource.data[widget.index] = element;
                            });
                            final editTableDataProvider =
                                Provider.of<EditTableDataProvider>(context,
                                    listen: false);

                            editTableDataProvider.setData(_historyDataSource);
                            // Navigator.of(context).pop();
                            tab.changeTab(tab.selectedIndexTmp);
                          },
                          color: Theme.of(context).accentColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Save',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 40,
            ),
            MediaQuery.of(context).size.width < 800
                ? Container()
                : Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.all(76),
                      color: Theme.of(context).accentColor,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 2,
                            right: 2,
                            child: IconButton(
                              color: Colors.black,
                              icon: Icon(LineAwesomeIcons.remove),
                              onPressed: () {},
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.all(46),
                              decoration: BoxDecoration(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
