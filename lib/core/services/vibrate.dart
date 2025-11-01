


import 'package:vibration/vibration.dart';

Future<void> vibrate() async{
  if (await Vibration.hasAmplitudeControl()) {
    Vibration.vibrate(amplitude: 128);
  }
}