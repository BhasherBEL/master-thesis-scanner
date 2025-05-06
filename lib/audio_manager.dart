import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioManager extends ChangeNotifier {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _player = AudioPlayer();
  String? _currentAudio;
  final List<String> _queue = [];

  String? get currentAudio => _currentAudio;
  List<String> get queue => List.unmodifiable(_queue);
  PlayerState _playerState = PlayerState.stopped;
  PlayerState get playerState => _playerState;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  Duration get position => _position;
  Duration get duration => _duration;

  void init() {
    _player.onPlayerStateChanged.listen((state) {
      _playerState = state;
      notifyListeners();
      if (state == PlayerState.completed) {
        _playNext();
      }
    });
    _player.onDurationChanged.listen((d) {
      _duration = d;
      notifyListeners();
    });
    _player.onPositionChanged.listen((p) {
      _position = p;
      notifyListeners();
    });
  }

  Future<void> play(String audioAsset) async {
    if (_currentAudio == audioAsset) {
      if (_playerState == PlayerState.playing) {
        await _player.pause();
      } else {
        await _player.resume();
      }
      return;
    }
    await _player.stop();
    _currentAudio = audioAsset;
    await _player.play(AssetSource(audioAsset));
    notifyListeners();
  }

  Future<void> pause() async {
    await _player.pause();
    notifyListeners();
  }

  Future<void> stop() async {
    await _player.stop();
    _currentAudio = null;
    notifyListeners();
  }

  void queueAudio(String audioAsset) {
    if (_queue.contains(audioAsset)) return;
    _queue.add(audioAsset);
    notifyListeners();
  }

  void removeFromQueue(String audioAsset) {
    _queue.remove(audioAsset);
    notifyListeners();
  }

  void _playNext() {
    if (_queue.isNotEmpty) {
      final next = _queue.removeAt(0);
      play(next);
    } else {
      _currentAudio = null;
      notifyListeners();
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
    notifyListeners();
  }
}
