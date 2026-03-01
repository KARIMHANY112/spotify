
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotifyy/models/music.dart';
import 'package:spotifyy/screens/home.dart';
import 'package:spotifyy/screens/search.dart';
import 'package:spotifyy/screens/yourlibrary.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<Widget> Tabs;
  int currentTabIndex = 0;
  bool isPlaying = false;
  Music? music;

  void updateMusic(Music? newMusic, {bool stop = false}) {
    setState(() {
      music = newMusic;
      if (stop) {
        isPlaying = false;
        _audioPlayer.stop();
      }
    });
  }

  Widget miniPlayer() {
    if (music == null) return const SizedBox();

    Size deviceSize = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: Colors.blueGrey,
      width: deviceSize.width,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(music!.image, fit: BoxFit.cover),
          Text(
            music!.name,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          IconButton(
            onPressed: () async {
              setState(() => isPlaying = !isPlaying);
              if (isPlaying) {
                await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(music!.audioURL)));
                await _audioPlayer.play();
              } else {
                await _audioPlayer.pause();
              }
            },
            icon: isPlaying
                ? const Icon(Icons.pause, color: Colors.white)
                : const Icon(Icons.play_arrow, color: Colors.white),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Tabs = [Home(updateMusic), Search(), YourLibrary()]; // ✅ pass updateMusic
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // ✅ clean up
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Tabs[currentTabIndex],
      backgroundColor: Colors.black,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          miniPlayer(), // ✅ no args, reads state
          BottomNavigationBar(
            currentIndex: currentTabIndex,
            onTap: (currentIndex) {
              setState(() => currentTabIndex = currentIndex);
            },
            selectedLabelStyle: const TextStyle(color: Colors.white),
            selectedItemColor: Colors.white,
            backgroundColor: Colors.black45,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.white), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search, color: Colors.white),
                  label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.library_books, color: Colors.white),
                  label: 'Your Library'),
            ],
          )
        ],
      ),
    );
  }
}