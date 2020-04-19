import 'package:volume/volume.dart';


// class providing action triggering
class TriggerLoader {
  // ===========================================================================
  // init variables
  final Map<String, String> actions = {
    'mute_phone':    'assets/icons/marker.png',
  };

  // ===========================================================================
  // define actions
  void mutePhone() async {
    await Volume.setVol(0, showVolumeUI: ShowVolumeUI.SHOW);
  }

  // ===========================================================================
}