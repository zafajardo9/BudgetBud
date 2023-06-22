import 'package:budget_bud/misc/colors.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../components/btn_icon_circle.dart';
import '../../main.dart';
import 'detail_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late final CameraController _controller;

  // Initializes camera controller to preview on screen
  void _initializeCamera() async {
    final CameraController cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );
    _controller = cameraController;

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  // Takes picture with the selected device camera, and
  // returns the image path
  Future<String?> _takePicture() async {
    if (!_controller.value.isInitialized) {
      print("Controller is not initialized");
      return null;
    }

    String? imagePath;

    if (_controller.value.isTakingPicture) {
      print("Processing is progress ...");
      return null;
    }

    try {
      // Turning off the camera flash
      _controller.setFlashMode(FlashMode.off);
      // Returns the image in cross-platform file abstraction
      final XFile file = await _controller.takePicture();
      // Retrieving the path
      imagePath = file.path;
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return imagePath;
  }

  @override
  void initState() {
    _initializeCamera();
    super.initState();
  }

  @override
  void dispose() {
    // dispose the camera controller when navigated
    // to a different page
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColorOne,
      appBar: AppBar(
        title: Text('Receipt Scanner v 0.2'),
        elevation: 0,
      ),
      body: _controller.value.isInitialized
          ? Column(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: CameraPreview(_controller),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: AppColors.mainColorOne,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            // If the returned path is not null, navigate to the DetailScreen
                            await _takePicture().then((String? path) {
                              if (path != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      imagePath: path,
                                    ),
                                  ),
                                );
                              } else {
                                print('Image path not found!');
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(16),
                            primary: AppColors
                                .mainColorFour, // Set the desired opacity background color
                            elevation:
                                0, // Remove the shadow by setting the elevation to 0
                          ),
                          child: Icon(
                            Icons.camera,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Tip: For long receipts, just snap the total amount section of the bill',
                          style: TextStyle(
                            color: AppColors.backgroundWhite,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
