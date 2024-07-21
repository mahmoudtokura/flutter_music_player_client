import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/view/widgets/music_player.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    final userFavoriteSongs = ref.watch(
      currentUserNotifierProvider.select((data) => data!.favorites),
    );
    if (currentSong == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(animation),
                child: const MusicPlayer(),
              );
            },
          ),
        );
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 66,
            width: MediaQuery.of(context).size.width - 16,
            decoration: BoxDecoration(
              color: hexToColor(currentSong.hex_code),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'music-image',
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(currentSong.thumbnail_url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentSong.song_title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          currentSong.artist,
                          style: const TextStyle(
                            color: Palette.subtitleText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await ref.read(homeViewModelProvider.notifier).favASong(
                              songId: currentSong.id.toString(),
                            );
                      },
                      icon: Icon(
                        userFavoriteSongs
                                .where((fav) => fav.song_id == currentSong.id)
                                .isNotEmpty
                            ? CupertinoIcons.heart_solid
                            : CupertinoIcons.heart,
                        color: Palette.whiteColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        songNotifier.playPause();
                      },
                      icon: Icon(
                        songNotifier.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Palette.whiteColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          StreamBuilder(
            stream: songNotifier.audioPlayer?.positionStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              final position = snapshot.data;
              final duration = songNotifier.audioPlayer!.duration;
              double sliderValue = 0.0;
              if (position != null && duration != null) {
                sliderValue = position.inMilliseconds / duration.inMilliseconds;
              }

              return Positioned(
                bottom: 0,
                left: 8,
                child: Container(
                  height: 2,
                  width: sliderValue * (MediaQuery.of(context).size.width - 32),
                  decoration: BoxDecoration(
                    color: Palette.whiteColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 8,
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                color: Palette.inactiveSeekColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
