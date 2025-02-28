import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDialogContent extends StatefulWidget {
  final String videoUrl;

  const VideoDialogContent({required this.videoUrl, Key? key}) : super(key: key);

  @override
  _VideoDialogContentState createState() => _VideoDialogContentState();
}

class _VideoDialogContentState extends State<VideoDialogContent> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.network(widget.videoUrl)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _controller.play();
              _controller.setLooping(true);
            });
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Failed to load video: $error';
            });
          }
        });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error creating video player: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set dialog width to 90% of screen width.
    final dialogWidth = MediaQuery.of(context).size.height /2;
    final dialogHeight = MediaQuery.of(context).size.height ;
    return Container(
      width: dialogWidth,
      height: dialogHeight,
      // Remove fixed height to allow the dialog to wrap content.
      padding: const EdgeInsets.all(16),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : _errorMessage != null
          ? Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      )
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The video is wrapped in an AspectRatio to enforce 16:9.
          SizedBox(
            width: dialogWidth,
            height: dialogHeight-150,
            child: VideoPlayer(_controller),
          ),
          const SizedBox(height: 16),
          // Controls row with play/pause and a cross button.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.pink,
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                    _isPlaying ? _controller.play() : _controller.pause();
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.pink),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog.
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
