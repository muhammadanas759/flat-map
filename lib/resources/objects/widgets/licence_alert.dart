import 'package:flatmapp/resources/objects/loaders/languages/languages_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preferences/preferences.dart';

// show licence dialog at startup
showLicenceAgreement(BuildContext context) async {
  bool isLicenceAccepted = PrefService.getBool("licence_accepted");
  if (isLicenceAccepted == false) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(LanguagesLoader.of(context).translate("Licence header")),
          content: Text(LanguagesLoader.of(context).translate("Licence text")),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                  LanguagesLoader.of(context).translate("Licence accept")),
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
                PrefService.setBool("licence_accepted", true);
              },
            ),
            new FlatButton(
              child: new Text(
                  LanguagesLoader.of(context).translate("Licence dismiss")),
              onPressed: () {
                // Close the app
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
