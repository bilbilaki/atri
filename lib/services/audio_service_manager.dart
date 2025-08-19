// Path: lib/services/audio_service_manager.dart
import 'package:audio_session/audio_session.dart';

class AudioServiceManager {
 static Future<void> initialize() async {
 final session = await AudioSession.instance;
 await session.configure(const AudioSessionConfiguration.music());
 await session.setActive(true);
 }
}