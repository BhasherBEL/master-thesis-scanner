import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SmallPlayer extends StatefulWidget {
  final String audioAsset;
  const SmallPlayer({Key? key, required this.audioAsset}) : super(key: key);

  @override
  State<SmallPlayer> createState() => _SmallPlayerState();
}

class _SmallPlayerState extends State<SmallPlayer> {
  late final AudioPlayer _player;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play(AssetSource(widget.audioAsset));
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
      ),
      iconSize: 32,
      tooltip: _isPlaying ? "Pause" : "Play",
      onPressed: _togglePlayPause,
    );
  }
}
