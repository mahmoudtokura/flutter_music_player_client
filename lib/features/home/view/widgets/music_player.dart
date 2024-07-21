import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final currentSongNotifier = ref.read(currentSongNotifierProvider.notifier);
    final userFavoriteSongs = ref.watch(
      currentUserNotifierProvider.select((data) => data!.favorites),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            hexToColor(currentSong!.hex_code),
            const Color(0xff121212),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Transform.translate(
            offset: const Offset(-10, 0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/pull-down-arrow.png",
                  color: Palette.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Hero(
                  tag: 'music-image',
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(currentSong.thumbnail_url),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_title,
                            style: const TextStyle(
                              color: Palette.whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(
                              color: Palette.subtitleText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(homeViewModelProvider.notifier)
                              .favASong(
                                songId: currentSong.id.toString(),
                              );
                        },
                        icon: Icon(
                          userFavoriteSongs
                                  .where((fav) => fav.song_id == currentSong.id)
                                  .isNotEmpty
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Palette.whiteColor,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  StreamBuilder(
                      stream: currentSongNotifier.audioPlayer!.positionStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LinearProgressIndicator(
                            value: 0.5,
                            backgroundColor: Palette.whiteColor,
                          );
                        }

                        final position = snapshot.data as Duration;
                        final duration = currentSongNotifier
                            .audioPlayer!.duration as Duration;

                        double sliderValue = 0;
                        if (duration.inSeconds > 0) {
                          sliderValue = position.inSeconds / duration.inSeconds;
                        }

                        return Column(
                          children: [
                            StatefulBuilder(
                              builder: (context, setState) => Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Palette.whiteColor,
                                    inactiveTrackColor:
                                        Palette.whiteColor.withOpacity(0.117),
                                    thumbColor: Palette.whiteColor,
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                  ),
                                  child: Slider(
                                    value: sliderValue,
                                    min: 0,
                                    max: 1,
                                    onChanged: (val) {
                                      sliderValue = val;
                                      setState(() {});
                                    },
                                    onChangeEnd: currentSongNotifier.seek,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${position.inMinutes}:${position.inSeconds}",
                                  style: const TextStyle(
                                    color: Palette.subtitleText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "${duration.inMinutes}:${duration.inSeconds}",
                                  style: const TextStyle(
                                    color: Palette.subtitleText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/shuffle.png",
                          color: Palette.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/previous-song.png",
                          color: Palette.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: currentSongNotifier.playPause,
                        icon: Icon(
                          currentSongNotifier.isPlaying
                              ? CupertinoIcons.pause_circle_fill
                              : CupertinoIcons.play_circle_fill,
                        ),
                        iconSize: 80,
                        color: Palette.whiteColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/next-song.png",
                          color: Palette.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/repeat.png",
                          color: Palette.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/connect-device.png",
                          color: Palette.whiteColor,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/playlist.png",
                          color: Palette.whiteColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
