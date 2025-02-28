import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class VideoContent extends StatefulWidget {
  final String videoUrl;

  const VideoContent({required this.videoUrl, Key? key}) : super(key: key);

  @override
  _VideoContentState createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  bool _isLoading = true;
  String? _errorMessage;
  html.VideoElement? _videoElement;
  html.DivElement? _videoContainer;
  double _top = 50.0; // Initial top position
  double _left = 50.0; // Initial left position
  double _width = 300.0; // Initial width for PiP
  double _height = 200.0; // Initial height for PiP
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    print('Initializing HTML video with URL: ${widget.videoUrl}'); // Debug log
    _checkVideoUrl().then((success) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = success ? null : 'Failed to load video URL';
          if (success) {
            _createVideoElement();
          }
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error loading video: $error';
        });
      }
    });
  }

  Future<bool> _checkVideoUrl() async {
    try {
      final request = await html.HttpRequest.request(widget.videoUrl, method: 'HEAD');
      return request.status == 200;
    } catch (e) {
      print('Video URL check error: $e');
      return false;
    }
  }

  void _createVideoElement() {
    _videoContainer = html.DivElement()
      ..style.position = 'fixed'
      ..style.width = '${_width}px'
      ..style.height = '${_height}px'
      ..style.backgroundColor = 'black'
      ..style.borderRadius = '8px'
      ..style.overflow = 'hidden'
      ..style.top = '${_top}px'
      ..style.left = '${_left}px'
      ..style.zIndex = '1000'; // Ensure it stays on top

    _videoElement = html.VideoElement()
      ..src = widget.videoUrl
      ..controls = true
      ..autoplay = true
      ..loop = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'contain'
      ..style.position = 'absolute'
      ..style.top = '0'
      ..style.left = '0';

    _videoContainer!.append(_videoElement!);
    html.document.body?.append(_videoContainer!);
  }

  @override
  void dispose() {
    if (_videoContainer != null) {
      _videoContainer!.remove();
      _videoContainer = null;
      _videoElement = null;
    }
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_isDragging) {
      setState(() {
        _top += details.delta.dy;
        _left += details.delta.dx;
        _videoContainer?.style.top = '${_top}px';
        _videoContainer?.style.left = '${_left}px';
      });
    }
  }

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator(color: Colors.pink))
        : _errorMessage != null
        ? Center(
      child: Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    )
        : GestureDetector(
      onPanUpdate: _handleDragUpdate,
      onPanStart: _handleDragStart,
      onPanEnd: _handleDragEnd,
      child: Stack(
        children: [
          Container(
            width: _width,
            height: _height,
            color: Colors.transparent,
            child: _videoElement != null
                ? HtmlElementView(
              viewType: 'htmlVideo-${widget.videoUrl.hashCode}',
            )
                : const SizedBox.shrink(),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.pink, size: 24),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  _videoElement?.remove();
                  _videoContainer?.remove();
                  _videoElement = null;
                  _videoContainer = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}