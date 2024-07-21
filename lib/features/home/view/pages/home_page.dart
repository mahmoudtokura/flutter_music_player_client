import 'package:client/core/theme/app_palette.dart';
import 'package:client/features/home/view/pages/library_page.dart';
import 'package:client/features/home/view/pages/songs_page.dart';
import 'package:client/features/home/view/widgets/music_slab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int tabIndex = 0;

  final List<Widget> pages = [
    const SongsPage(),
    const LibraryPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[tabIndex],
          const Positioned(
            bottom: 0,
            child: MusicSlab(),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabIndex,
        onTap: (value) => setState(() => tabIndex = value),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              tabIndex == 0
                  ? "assets/images/home_filled.png"
                  : "assets/images/home_unfilled.png",
              color: tabIndex == 0
                  ? Palette.whiteColor
                  : Palette.inactiveBottomBarItemColor,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/library.png",
              color: tabIndex == 1
                  ? Palette.whiteColor
                  : Palette.inactiveBottomBarItemColor,
            ),
            label: "Library",
          ),
        ],
      ),
    );
  }
}
