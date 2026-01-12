import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:unio/resources/auth_methods.dart';
import 'package:unio/resources/firestore_methods.dart';

class JitsiMeetMethods {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();
  // Use the singleton instance
  final _jitsiMeet = JitsiMeet();

  void createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = '',
  }) async {
    try {
      String name;
      if (username.isEmpty) {
        name = _authMethods.user.displayName!;
      } else {
        name = username;
      }

      final userInfo = JitsiMeetUserInfo(
        displayName: name,
        email: _authMethods.user.email,
        avatar: _authMethods.user.photoURL,
      );

      final featureFlags = {
        'welcomepage.enabled': false,
        'resolution': 360,
      };

      final configOverrides = {
        'serverURL': 'https://call.unio.my',
        'startWithAudioMuted': isAudioMuted,
        'startWithVideoMuted': isVideoMuted,
      };

      final options = JitsiMeetConferenceOptions(
        room: roomName,
        userInfo: userInfo,
        featureFlags: featureFlags,
        configOverrides: configOverrides,
      );

      _firestoreMethods.addToMeetingHistory(roomName);
      // Use the singleton instance to join the meeting
      await _jitsiMeet.join(options);
    } catch (error) {
      print("error: $error");
    }
  }
}
