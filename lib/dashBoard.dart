// import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:bot_toast/bot_toast.dart';
//
// class Dashboard extends StatefulWidget {
//   @override
//   _DashboardState createState() => _DashboardState();
// }
//
// class _DashboardState extends State<Dashboard> {
//   final _textFormKey = GlobalKey<FormState>();
//
//   TextEditingController _descriptionController = TextEditingController();
//   String minPickupTime;
//   String maxPickupTime;
//   List<int> _prices = [10, 20, 30];
//   List<int> _quantity = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
//   int _currentPrice = 10;
//   int _currentQuantity = 1;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Dashboard"),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Padding(
//             padding: EdgeInsets.all(8),
//             child: Form(
//               key: _textFormKey,
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
// //Quantity Selection
//                   Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8),
//                         child: Text(
//                           "Select Quantity:",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: DropdownButton<int>(
//                             items: _quantity.map((e) {
//                               return DropdownMenuItem<int>(
//                                 value: e,
//                                 child: Text(e.toString()),
//                               );
//                             }).toList(),
//                             value: _currentQuantity,
//                             onChanged: (int newItemSelected) {
//                               return onChangedDropdown(
//                                   isQuantity: true,
//                                   newItemSelected: newItemSelected);
//                             }),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
// //Price Selection
//                   Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           "Select Price(lei):",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: DropdownButton<int>(
//                             items: _prices.map((e) {
//                               return DropdownMenuItem<int>(
//                                 value: e,
//                                 child: Text(e.toString()),
//                               );
//                             }).toList(),
//                             value: _currentPrice,
//                             onChanged: (int newItemSelected) {
//                               return onChangedDropdown(
//                                   isQuantity: false,
//                                   newItemSelected: newItemSelected);
//                             }),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
// //Description
//                   TextFormField(
//                     controller: _descriptionController,
//                     keyboardType: TextInputType.text,
//                     validator: (val) {
//                       if(val==null){
//                         return null;
//                       }
//                       if (val.isEmpty) {
//                         return "Field is Empty";
//                       } else if (val.trim().length > 500) {
//                         return "Description Limit is 500 words! While current length is ${val.trim().length}";
//                       } else {
//                         return null;
//                       }
//                     },
//                     // onSaved: (val) => phoneNo = val,
//                     autofocus: true,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: "Description",
//                       labelStyle: TextStyle(fontSize: 15.0),
//                       hintText: "Please enter item's description",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//
//                   Row(
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               "Select Food Pickup Time:",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: RaisedButton(
//                               onPressed: () => setTime(isMin: true),
//                               color: Colors.white,
//                               elevation: 5,
//                               child: Text("Starting Time"),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: RaisedButton(
//                               color: Colors.white,
//                               elevation: 5,
//                               onPressed: () => setTime(isMin: false),
//                               child: Text(maxPickupTime != null
//                                   ? maxPickupTime
//                                   : "Finishing Time"),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: Text(minPickupTime != null
//                                 ? minPickupTime.toString()
//                                 : ""),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: Text(maxPickupTime != null
//                                 ? maxPickupTime.toString()
//                                 : ""),
//                           ),
//                         ],
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   onChangedDropdown({required var newItemSelected, required bool isQuantity}) {
//     setState(() {
//       if (isQuantity)
//         this._currentQuantity = newItemSelected;
//       else
//         this._currentPrice = newItemSelected;
//     });
//   }
//
//   setTime({required bool isMin}) {
//     DateTime pickupTime;
//     DatePicker.showTime12hPicker(
//       context,
//       showTitleActions: true,
//       onChanged: (date) {
//         print('change $date in time zone ' +
//             date.timeZoneOffset.inHours.toString());
//       },
//       onConfirm: (date) {
//         setState(() {
//           pickupTime = date;
//         });
//         String onlyTime =
//             "${pickupTime.hour}H:${pickupTime.minute}M:${pickupTime.second}S";
//         if (isMin) {
//           setState(() {
//             minPickupTime = onlyTime;
//           });
//         } else {
//           setState(() {
//             maxPickupTime = onlyTime;
//           });
//         }
//         print(minPickupTime);
//         //liveDateSelected = true;
//         if (pickupTime != null) {
//         } else {
//           BotToast.showText(text: "Date was not selected correctly");
//         }
//       },
//       currentTime: DateTime.now(),
//     );
//   }
// }
