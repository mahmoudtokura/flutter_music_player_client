import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getAllFavoriteSongsProvider).when(
          data: (data) {
            return Builder(
              builder: (context) {
                return ListView.builder(
                  itemCount: data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == data.length) {
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const UploadSongPage(),
                            ),
                          );
                        },
                        leading: const CircleAvatar(
                          radius: 35,
                          child: Icon(CupertinoIcons.add),
                        ),
                        title: const Text(
                          "Add new song",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }
                    final song = data[index];
                    return ListTile(
                      onTap: () => ref
                          .read(currentSongNotifierProvider.notifier)
                          .updateSong(song),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(song.thumbnail_url),
                        radius: 35,
                      ),
                      title: Text(
                        song.song_title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        song.artist,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          error: (error, stackTrace) => Center(
            child: Text(
              error.toString(),
            ),
          ),
          loading: () {
            return const Loader();
          },
        );
    return Container();
  }
}
