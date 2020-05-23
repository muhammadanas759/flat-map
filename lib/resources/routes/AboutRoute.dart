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

      // BODY
      ListView(
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
            ListTile(
              title: Text(
                'FlatMapp is an engineering project, aiming at creation of '
                'geolocation manager, triggering user-defined actions in '
                'declared geographical position.',
                style: bodyText(),
              ),
            ),
            ListTile(
              title: Text(
                'FlatMapp is free to use and is not gathering any personal data '
                'without user consent. All data gathered from application, such '
                'as user settings, saved locations or custom triggers, is '
                'anonymized before gathering. ',
                style: bodyText(),
              ),
            ),

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


            ListTile(
              title: Text(
                'Please rate our effort on Google Play Store!',
                style: bodyText(),
              ),
              trailing: Icon(Icons.star_border),
              onTap: (){
                // TODO go to Google Play app review
              },
            ),

            ListTile(
              title: Text(
                'FlatMapp Team @ 2020',
                style: footer(),
              ),
            ),
          ],
        ).toList(),
      ),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}
