import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutRoute extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                title: Text(
                  'About',
                  style: header(),
                ),
                leading: Icon(Icons.info_outline),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text(
                  'FlatMapp is an engineering project, aiming at creation of '
                  'geolocation manager, triggering user-defined actions in '
                  'declared geographical position.',
                  style: bodyText(),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text(
                  'FlatMapp is free to use and is not gathering any personal data '
                  'without user consent.',
                  style: bodyText(),
                ),
              ),
              SizedBox(height: 10),

              ListTile(
                title: Linkify(
                  text: "Application repository: \nhttps://github.com/AdamLewicki/flatmapp_app",
                  onOpen: (link) async {
                    if (await canLaunch(link.url)) {
                      await launch(link.url);
                    } else {
                      // show message
                      Fluttertoast.showToast(
                        msg: 'Could not launch $link',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  style: bodyText(),
                  linkStyle: TextStyle(color: Colors.green),
                ),
                trailing: Icon(Icons.link),
              ),
              SizedBox(height: 10),

              ListTile(
                title: SelectableLinkify(
                  text: "Server repository: \nhttps://github.com/AdamLewicki/flatmapp_server",
                  onOpen: (link) async {
                    if (await canLaunch(link.url)) {
                      await launch(link.url);
                    } else {
                      // show message
                      Fluttertoast.showToast(
                        msg: 'Could not launch $link',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  style: bodyText(),
                  linkStyle: TextStyle(color: Colors.green),
                ),
                trailing: Icon(Icons.link),
              ),
              SizedBox(height: 10),

              ListTile(
                title: SelectableLinkify(
                  text: "Test report: \nhttps://forms.gle/T4XomZRWfQ1iRBQD8",
                  onOpen: (link) async {
                    Fluttertoast.showToast(
                      msg: 'Opening test report...',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    if (await canLaunch(link.url)) {
                      await launch(link.url);
                    } else {
                      // show message
                      Fluttertoast.showToast(
                        msg: 'Could not launch $link',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  style: bodyText(),
                  linkStyle: TextStyle(color: Colors.green),
                ),
                trailing: Icon(Icons.link),
              ),
              SizedBox(height: 10),

              ListTile(
                title: SelectableLinkify(
                  text: "Bug report: \nhttps://forms.gle/V7MRhwb7fDVFc8TV8",
                  onOpen: (link) async {
                    Fluttertoast.showToast(
                      msg: 'Opening bug report...',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    if (await canLaunch(link.url)) {
                      await launch(link.url);
                    } else {
                      // show message
                      Fluttertoast.showToast(
                        msg: 'Could not launch $link',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  style: bodyText(),
                  linkStyle: TextStyle(color: Colors.green),
                ),
                trailing: Icon(Icons.link),
              ),
              SizedBox(height: 10),

              // Container(
              //   decoration: buttonFieldStyle(),
              //   child: ListTile(
              //     title: Text(
              //       'Please rate our effort on Google Play Store!',
              //       style: bodyText(),
              //     ),
              //     trailing: Icon(Icons.star_border),
              //     onTap: (){
              //       // TODO go to Google Play app review
              //     },
              //   ),
              // ),
              // SizedBox(height: 10),

              ListTile(
                title: Text(
                  'FlatMapp Team @ 2020',
                  style: footer(),
                ),
              ),
            ],
          ).toList(),
        ),
      ),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}
