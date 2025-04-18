import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioBar extends StatefulWidget {
  final String audioAsset;
  const AudioBar({super.key, required this.audioAsset});

  @override
  State<AudioBar> createState() => _AudioBarState();
}

class _AudioBarState extends State<AudioBar> {
  late final AudioPlayer player;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() {
        duration = d;
      });
    });
    player.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() {
        position = p;
      });
    });
    player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    var min = d.inMinutes.remainder(60).toString().padLeft(1, '0');
    var sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 32),
            onPressed: () async {
              if (isPlaying) {
                await player.pause();
              } else {
                await player.play(AssetSource(widget.audioAsset));
              }
            },
          ),
          Text(
            "${_formatDuration(position)} / ${_formatDuration(duration)}",
            style: const TextStyle(fontSize: 16),
          ),
          Expanded(
            child: Slider(
              min: 0,
              max: duration.inSeconds.toDouble().clamp(1, double.infinity),
              value: position.inSeconds.toDouble().clamp(
                0,
                duration.inSeconds.toDouble(),
              ),
              onChanged: (value) async {
                final seekPos = Duration(seconds: value.toInt());
                await player.seek(seekPos);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.fast_rewind),
            onPressed: () async {
              await player.seek(
                Duration(
                  seconds: (position.inSeconds - 10).clamp(
                    0,
                    duration.inSeconds,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.fast_forward),
            onPressed: () async {
              await player.seek(
                Duration(
                  seconds: (position.inSeconds + 10).clamp(
                    0,
                    duration.inSeconds,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
