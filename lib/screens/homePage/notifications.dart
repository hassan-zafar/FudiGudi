import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/commonUIFunctions.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/models/notificationsModel.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeAgo;

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationData> allNotifications = [];
  bool hasNotifications = true;

  @override
  void initState() {
    super.initState();
    getNoti();
  }

  getNoti() async {
    allNotifications = await getNotifications();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundColorBoxDecoration(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Icon(
              Icons.search,
              color: Colors.black,
            )
          ],
          title: Text(
            "Notifications",
            style: titleTextStyle(),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: allNotifications == null
            ? Center(
                child: Container(
                  child: Text("Currently No Notification"),
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return notificationsCard(index);
                },
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: allNotifications.length,
              ),
      ),
    );
  }

  Padding notificationsCard(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: bxShadow,
            borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.green[100],
                    radius: 40,
                    backgroundImage: CachedNetworkImageProvider(
                        allNotifications[index].userImage),
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          allNotifications[index].title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(allNotifications[index].message),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 2,
              right: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  timeAgo.format(allNotifications[index].dateTime),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
