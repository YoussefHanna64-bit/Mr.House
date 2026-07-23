import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LecturePlaybackView extends StatefulWidget {
  final Map<String, dynamic> videoData;

  const LecturePlaybackView({super.key, required this.videoData});

  @override
  State<LecturePlaybackView> createState() => _LecturePlaybackScreenState();
}

class _LecturePlaybackScreenState extends State<LecturePlaybackView> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoData["url"])!,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: isLandscape
          ? null
          : AppBar(
              title: Text(widget.videoData["name"] ?? "Video",
                  style: const TextStyle(fontSize: 30)),
              centerTitle: true),
      body: Center(
          child: YoutubePlayer(
              controller: _controller, showVideoProgressIndicator: true)),
    );
  }
}
