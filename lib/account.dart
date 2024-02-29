import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:findpro/global/Constants.dart';
import 'package:findpro/models/usersModel.dart';
import 'package:findpro/screens/bottomNav.dart';
import 'package:findpro/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyAccount extends StatefulWidget {
  const MyAccount({super.key, required this.title});

  final String title;

  @override
  State<MyAccount> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyAccount> {
  String dropdowncat = 'Item 1';
  String dropdownsubcat = 'Select your services*';
  String dropdowncode = '+91';
  String dropdowngender = 'Select Gender';
  String dropdowncountry = 'Select Country';
  bool _isVisible = true;
  final _formKeyy = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  XFile? image;
  final ImagePicker imagePicker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await imagePicker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            title: Text('Please choose media to select'),
            content: Container(
              height: 110,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      //if user click this button. user can upload image from camera
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.camera);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.camera),
                          Text('From Camera'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  var country = [
    'Select Country',
    'India',
    'Canada',
    'Pakistan',
  ];

  var gender = [
    'Select Gender',
    'Male',
    'Female',
  ];

  var code = [
    '+91',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  var subcat = [
    'Select your services*',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];


  String profilePic = '';
  static String name = '';
  static String email = '';

  int counter = 0;
  late Timer _timer;

  stopCounter() {
    _timer.cancel();
  }

  update() async {
    // _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print('sujegfdhfjdh $email');
      profilePic = prefs.getString('avatar') ?? '';
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
    });
    // });
  }

  _nameRetriever() async {
    if(profilePic.isEmpty){
      update();
    } else{
      stopCounter();
    }
  }

  @override
  void initState() {
    print('sujehfjdh $name');
    print('sujehfjdh $email');
    print('sujehfjdh $profilePic');

    _nameRetriever();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child:
          Container(
            padding: EdgeInsets.only(
              top: 5.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onPressed: () {
                      Navigator.pop(context);
                      // _key.currentState!.openDrawer();
                    }, icon: Icon(Icons.arrow_back,size: 25,)),

                // AutocompleteBasicExample(),
                Container(
                    height: 43.h,
                    alignment: Alignment.center,
                    padding: EdgeInsets.zero,
                    child: Text('Settings',style: TextStyle(fontSize: 30.sp),)
                   
                ),

               Container(
                   margin: EdgeInsets.only(right: 15.w),
                   child: Text('save',style: TextStyle(fontSize: 20.sp)))
              ],
            ),
          ),
        ),
        body: Center(
          widthFactor: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: _formKeyy,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                    Widget>[
                  SizedBox(height: 5.h,),
                  Stack(
                    children: [
                    (profilePic.isNotEmpty)?
                      Container(
                        decoration: BoxDecoration(
                            color: ColorConstants.backgroundColor,
                            shape: BoxShape.circle,
                        ),
                        child:  ClipOval(
                              child: Image.network(profilePic, height: 100.h,
                                width: 100.w,)),

                      ):
                     Container(
                    decoration: BoxDecoration(
                      color: ColorConstants.themeBlue,
                      shape: BoxShape
                          .circle,
                    ),

                    child: Image.asset(
                        'assets/images/logo.png',
                        height: 100.h,
                        width: 100.w,
                        fit: BoxFit.fitWidth),
                  ),

                      Positioned.fill(
                        // top: 30,
                        //   left: 20,
                          child: Align(
                              alignment: Alignment.center,
                              child: Container(

                                  padding: EdgeInsets.only(right: 20.w,top: 20.h,bottom: 20.h,left: 20.w),
                                  margin: EdgeInsets.only(right: 5.w,left: 5.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // borderRadius: BorderRadius.only(bottomRight: Radius.circular(100),bottomLeft:Radius.circular(100) ),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: Icon(Icons.camera_enhance_rounded,color: Colors.white,)))),
                    ],
                  ),

                  SizedBox(height: 5.h,),
                  Container(
                    // width:210.w,
                    child: Text(
                      name,
                      softWrap: true,
                      maxLines: 2,
                      textScaleFactor:
                      1.0,
                      style:
                      TextStyle(
                        fontFamily:
                        'DMSans-Bold',
                        fontWeight:
                        FontWeight
                            .w400,
                        fontSize:
                        22.sp,
                        color: Colors
                            .black,
                      ),
                    ),
                  ),
                  Container(
                    // width:210.w,
                    child: Text(
                      email,
                      softWrap: true,
                      maxLines: 2,
                      textScaleFactor:
                      1.0,
                      style:
                      TextStyle(
                        fontFamily:
                        'DMSans-Bold',
                        fontWeight:
                        FontWeight
                            .w400,
                        fontSize:
                        22.sp,
                        color: Colors
                            .black,
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10, right: 40, left: 40),
                    child: DropdownButtonFormField2(
                      hint: const Text(
                        'Select Your Profession',
                        style: TextStyle(fontSize: 14),
                      ),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.work_outlined),
                        enabledBorder: OutlineInputBorder(
                          //<-- SEE HERE
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          //<-- SEE HERE
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      value: dropdowncat,

                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter a valid email address";
                        } else
                          return null;
                      },
                      // Down Arrow Icon
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                        ),
                      ),

                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                          alignment: Alignment.center,
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdowncat = newValue!;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10, right: 40, left: 40),
                    child: DropdownButtonFormField(
                      hint: const Text(
                        'Select Your Profession',
                        style: TextStyle(fontSize: 14),
                      ),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.design_services),
                        enabledBorder: OutlineInputBorder(
                          //<-- SEE HERE
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          //<-- SEE HERE
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      value: dropdownsubcat,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: subcat.map((String items) {
                        return DropdownMenuItem(
                          onTap: () {
                            // _isVisible = !_isVisible;
                          },
                          value: items,
                          child: Text(items),
                          alignment: Alignment.center,
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownsubcat = newValue!;
                        });
                      },
                    ),
                  ),

                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, right: 40, left: 40),
                      // padding: EdgeInsets.all(15),
                      child: TextFormField(

                        // obscureText: true,
                        initialValue: name.toString(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'FULL NAME',
                          hintText: 'Name*',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter user name";
                          } else
                            return null;
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, right: 40, left: 40),
                      // padding: EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: email,
                        // obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter a valid email address";
                          } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return "Enter a valid email address";
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'EMAIL',
                          hintText: 'Email Id*',
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, right: 40, left: 40),
                      // padding: EdgeInsets.all(15),
                      child: TextFormField(
                        // obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required";
                          } else if (value.length < 8) {
                            return "Password should be atleast 8 characters";
                          } else if (value.length > 15) {
                            return "Password should not be greater than 15 characters";
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Password*',
                          icon: Icon(Icons.lock_open),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, right: 40, left: 40),
                      // padding: EdgeInsets.all(15),
                      child: TextFormField(
                        showCursor: true,
                        // obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required";
                          } else if (value.length < 8) {
                            return "Password should be atleast 8 characters";
                          } else if (value.length > 15) {
                            return "Password should not be greater than 15 characters";
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Confirm Password*',
                          icon: Icon(Icons.lock),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 56,
                            margin: EdgeInsets.only(top: 10, left: 40, right: 10),
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              decoration: const InputDecoration(
                                // prefixIcon: Icon(Icons.language),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              value: dropdowncode,

                              // Down Arrow Icon
                              alignment: Alignment.centerRight,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              // alignment: Alignment.centerRight,
                              items: code.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                  alignment: Alignment.center,
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdowncode = newValue!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 10, right: 40),
                              // padding: EdgeInsets.all(15),
                              child: TextFormField(
                                showCursor: true,
                                // obscureText: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter your Phone No.";
                                  } else
                                    return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Phone*',
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, right: 40, left: 40),
                      child: DropdownButtonFormField2(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.male),
                          enabledBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide: BorderSide(color: Colors.grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide: BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select gender.';
                          }
                          return null;
                        },
                        value: dropdowngender,

                        // Down Arrow Icon
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                          ),
                        ),

                        // Array list of items
                        items: gender.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                            alignment: Alignment.center,
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdowngender = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, right: 40, left: 40),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.flag),
                          enabledBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide: BorderSide(color: Colors.grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide: BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        value: dropdowncountry,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: country.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                            alignment: Alignment.center,
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdowncountry = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, right: 40, left: 40),
                      // padding: EdgeInsets.all(15),
                      child: TextFormField(
                        showCursor: true,
                        // obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your Address";
                          } else if (value.length < 20) {
                            return "Address must have 20 characters";
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Full Address*',
                          icon: Icon(Icons.map),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, right: 40, left: 40),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.language_rounded),
                          enabledBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide: BorderSide(color: Colors.grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide: BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        value: dropdowncountry,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: country.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                            alignment: Alignment.center,
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdowncountry = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, right: 40, left: 40),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.location_city),
                          enabledBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide: BorderSide(color: Colors.grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide: BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        value: dropdowncountry,

                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          } else
                            return null;
                        },
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: country.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                            alignment: Alignment.center,
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdowncountry = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, right: 40, left: 40),
                      // padding: EdgeInsets.all(15),
                      child: TextFormField(
                        showCursor: true,
                        // obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your Pin Code";
                          } else
                            return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Pin Code*',
                          icon: Icon(Icons.pin_drop),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, right: 40, left: 40),
                      // padding: EdgeInsets.all(15),
                      child: SizedBox(
                        height: 100,
                        child: TextFormField(
                          maxLines: null,
                          expands: true,
                          keyboardType: TextInputType.multiline,
                          showCursor: true,
                          // obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your description";
                            } else if (value.length < 100) {
                              return "About Me length should not be less than 100 characters";
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'About Me*',
                            icon: Icon(Icons.question_mark),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(5.0)),
                      height: 200,
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          top: 10, right: 40, left: 40, bottom: 10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(bottom: 10),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Personal Profile Image *",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            image != null
                                ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                // child: Image.file(
                                //   // to show image, you type like this.
                                //   File(image.path),
                                //   fit: BoxFit.cover,
                                //   width: MediaQuery.of(context).size.width,
                                //   height: 100,
                                // ),
                              ),
                            )
                                : const Text(
                              "No Image",
                              style: TextStyle(fontSize: 20),
                            ),
                            Container(
                              width: double.infinity,
                              // alignment: Alignment.bottomLeft,
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.cloud_upload),
                                label: Text("Upload"),
                                onPressed: () {
                                  myAlert();
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                                ),
                              ),
                            )
                          ]),
                      // ]
                    ),
                  ),
                  Visibility(
                      visible: _isVisible,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKeyy.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Data is in processing.")));
                            }
                          },
                          child: Text("Preview"))),

                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
