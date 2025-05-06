import 'package:flutter/material.dart';
import 'package:thesis_scanner/audio_manager.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioBar extends StatefulWidget {
  final String audioAsset;
  const AudioBar({super.key, required this.audioAsset});

  @override
  State<AudioBar> createState() => _AudioBarState();
}

class _AudioBarState extends State<AudioBar> {
  final AudioManager audioManager = AudioManager();
  PlayerState playerState = PlayerState.stopped;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioManager.init();
    audioManager.addListener(_onAudioManagerChanged);
    if (audioManager.currentAudio == widget.audioAsset) {
      playerState = audioManager.playerState;
      position = audioManager.position;
      duration = audioManager.duration;
    }
  }

  @override
  void dispose() {
    audioManager.removeListener(_onAudioManagerChanged);
    super.dispose();
  }

  void _onAudioManagerChanged() {
    if (!mounted) return;
    setState(() {
      if (audioManager.currentAudio == widget.audioAsset) {
        playerState = audioManager.playerState;
        position = audioManager.position;
        duration = audioManager.duration;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCurrent = audioManager.currentAudio == widget.audioAsset;
    final isPlaying = isCurrent && playerState == PlayerState.playing;
    final isPaused = isCurrent && playerState == PlayerState.paused;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 32),
            onPressed: () async {
              if (isCurrent) {
                if (isPlaying) {
                  await audioManager.pause();
                } else {
                  await audioManager.play(widget.audioAsset);
                }
              } else {
                await audioManager.play(widget.audioAsset);
              }
            },
          ),
          Expanded(
            child:
                isCurrent
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 6,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 16,
                            ),
                            activeTrackColor: Theme.of(context).primaryColor,
                            inactiveTrackColor: Colors.grey[300],
                            thumbColor: Theme.of(context).primaryColor,
                          ),
                          child: Slider(
                            min: 0,
                            max:
                                duration.inMilliseconds > 0
                                    ? duration.inMilliseconds.toDouble()
                                    : 1,
                            value:
                                position.inMilliseconds
                                    .clamp(
                                      0,
                                      duration.inMilliseconds > 0
                                          ? duration.inMilliseconds
                                          : 1,
                                    )
                                    .toDouble(),
                            onChanged: (value) async {
                              final seekTo = Duration(
                                milliseconds: value.round(),
                              );
                              await audioManager.seek(seekTo);
                            },
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 6,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 0,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 0,
                            ),
                            activeTrackColor: Colors.grey[300],
                            inactiveTrackColor: Colors.grey[300],
                            thumbColor: Colors.transparent,
                            disabledActiveTrackColor: Colors.grey[300],
                            disabledInactiveTrackColor: Colors.grey[300],
                          ),
                          child: const Slider(
                            min: 0,
                            max: 1,
                            value: 0,
                            onChanged: null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "00:00",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              "00:00",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
