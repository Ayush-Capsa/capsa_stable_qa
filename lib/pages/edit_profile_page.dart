import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/models/profile_model.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController(text: '');
  final emailController = TextEditingController(text: '');
  final numberController = TextEditingController(text: '');
  final addressController = TextEditingController(text: '');
  final cityController = TextEditingController(text: '');
  final stateController = TextEditingController(text: '');
  final designationController = TextEditingController(text: 'Vendor');
  String _state = '';
  final _formKey = GlobalKey<FormState>();

  String _city = '';

  String _address = '';
  String _name = '';
  String _designation = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<ProfileProvider>(context, listen: false).queryProfile();
    Provider.of<ProfileProvider>(context, listen: false).queryFewData();
    final Box box = Hive.box('capsaBox');

    _designation = "Vendor";
    var userData = Map<String, dynamic>.from(box.get('userData'));
    String _role = userData['role'];

    if (_role == "INVESTOR") _designation = "Investor";
    designationController.text = _designation;
  }

  bool saving = false;

  bool isSet = false;

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    UserData userDetails = profileProvider.userDetails;

    if (!saving) {
      nameController.text = userDetails.nm;
      emailController.text = userDetails.email;
      numberController.text = userDetails.contact;
      addressController.text = userDetails.ADD_LINE;
      cityController.text = userDetails.CITY;
      stateController.text = userDetails.STATE;

      _address = userDetails.ADD_LINE;
      _state = userDetails.STATE;
      _city = userDetails.CITY;
      _name = userDetails.nm;

      isSet = true;
    }
    final Box box = Hive.box('capsaBox');

    return SingleChildScrollView(
      child: Container(
        // height: MediaQuery.of(context).size.height,

        padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 22,
              ),
              TopBarWidget("Edit Profile", "*If you would like to change your number or email address. Please contact support@getcapsa.com"),
              Text(
                "",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              // SizedBox(
              //   height: 15,
              // ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("assets/images/Ellipse 3.png"),
                          height: 70,
                          width: 70,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    OrientationSwitcher(
                      children: [
                        Flexible(
                          child: UserTextFormField(
                            label: "Name",
                            hintText: "Name",
                            controller: nameController,
                            onChanged: (v) {
                              _name = v;
                            },
                          ),
                        ),
                        Flexible(
                          child: UserTextFormField(
                            label: "Designation",
                            hintText: "Designation",
                            readOnly: true,
                            controller: designationController,
                          ),
                        )
                      ],
                    ),
                    OrientationSwitcher(
                      children: [
                        Flexible(
                          child: UserTextFormField(
                            label: "Email",
                            hintText: "Email",
                            readOnly: true,
                            controller: emailController,
                          ),
                        ),
                        Flexible(
                          child: UserTextFormField(
                            label: "Phone number",
                            hintText: "Phone number",
                            readOnly: true,
                            controller: numberController,
                          ),
                        )
                      ],
                    ),
                    OrientationSwitcher(
                      children: [
                        Flexible(
                          child: UserTextFormField(
                            label: "Address",
                            hintText: "Address",
                            controller: addressController,
                            onChanged: (v) {
                              _address = v;
                            },
                          ),
                        ),
                      ],
                    ),
                    OrientationSwitcher(
                      children: [
                        Flexible(
                          child: UserTextFormField(
                            label: "State",
                            hintText: "State",
                            controller: stateController,
                            onChanged: (v) {
                              _state = v;
                            },
                          ),
                        ),
                        Flexible(
                          child: UserTextFormField(
                            label: "City ",
                            hintText: "City ",
                            controller: cityController,
                            onChanged: (v) {
                              _city = v;
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    if (saving)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              saving = true;
                            });
                            var userData = Map<String, dynamic>.from(box.get('userData'));
                            var _body = {};
                            _body['address'] = _address;
                            _body['city'] = _city;
                            _body['state'] = _state;
                            _body['name'] = _name;
                            _body['panNumber'] = userData['panNumber'];

                            dynamic response = await profileProvider.updateData(_body);

                            if (response['res'] == 'success') {
                              UserData _user = UserData(
                                _address,
                                _city,
                                userDetails.COUNTRY,
                                _state,
                                userDetails.cc,
                                userDetails.contact,
                                userDetails.email,
                                _name,
                              );
                              // profileProvider.addUser(_user);
                              await profileProvider.queryProfile();
                              await profileProvider.queryFewData();

                              // setState(() {
                              //   saving = false;
                              // });
                              context.beamToNamed('/profile');
                              showToast('Profile details successfully updated', context);
                              // context.beamBack();
                            } else {
                              showToast('Something Wrong! Unable to update. Try again later', context, type: 'error');
                              setState(() {
                                saving = false;
                              });
                            }
                          }
                        },
                        child: Container(
                            width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.8 : 200,
                            height: 59,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                      color: Color.fromRGBO(0, 152, 219, 1),
                                    ),
                                    width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.8 : 200,
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Save',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color.fromRGBO(242, 242, 242, 1),
                                                fontFamily: 'Poppins',
                                                fontSize: 18,
                                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.normal,
                                                height: 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ])),
                      ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
