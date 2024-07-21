import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String audioPath;
  const AudioWave({
    super.key,
    required this.audioPath,
  });

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController playerController = PlayerController();

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    await playerController.preparePlayer(path: widget.audioPath);
  }

  Future<void> playAndPause() async {
    if (!playerController.playerState.isPlaying) {
      await playerController.startPlayer(finishMode: FinishMode.stop);
    } else if (!playerController.playerState.isPaused) {
      await playerController.pausePlayer();
    }
    setState(() {});
    print(playerController.playerState.isPlaying);
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: playAndPause,
          icon: Icon(
            playerController.playerState.isPlaying
                ? Icons.pause
                : Icons.play_arrow,
          ),
        ),
        Expanded(
          child: AudioFileWaveforms(
            size: Size(MediaQuery.of(context).size.width, 100.0),
            playerController: playerController,
            enableSeekGesture: true,
            waveformType: WaveformType.long,
            waveformData: const [],
            playerWaveStyle: const PlayerWaveStyle(
              fixedWaveColor: Palette.borderColor,
              liveWaveColor: Palette.gradient1,
              spacing: 6,
              showSeekLine: false,
            ),
          ),
        ),
      ],
    );
  }
}
