import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Picture Frame',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PictureFrame(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PictureFrame extends StatefulWidget {
  const PictureFrame({super.key});

  @override
  _PictureFrameState createState() => _PictureFrameState();
}

class _PictureFrameState extends State<PictureFrame> {
  final List<String> _imageUrls = [
    // Replace with your S3 bucket image URLs
    'https://bucketforsita.s3.amazonaws.com/image1.jpg',
    'https://bucketforsita.s3.amazonaws.com/image2.jpg',
    'https://bucketforsita.s3.amazonaws.com/image3.jpg',
    'https://bucketforsita.s3.amazonaws.com/image4.jpg',
  ];

  int _currentImageIndex = 0;
  bool _isPaused = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startImageRotation();
  }

  void _startImageRotation() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!_isPaused) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % _imageUrls.length;
        });
      }
    });
  }

  void _togglePauseResume() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Picture Frame'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent, width: 8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              _imageUrls[_currentImageIndex],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text('Error loading image'),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePauseResume,
        tooltip: _isPaused ? 'Resume' : 'Pause',
        child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
      ),
    );
  }
}
