import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DetailScreen extends StatefulWidget {
  final String imagePath;

  const DetailScreen({required this.imagePath});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final String _imagePath;
  late final TextRecognizer _textRecognizer;
  Size? _imageSize;
  List<String> _listEmailStrings = [];
  List<String> _listPriceStrings = [];
  List<String> _listAllStrings = [];
  String _extractedTotalText = ""; // New variable
  List<TextElement> _elements = [];

  // Fetching the image size from the image file
  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  // To detect the email addresses present in an image
//   void _recognizeEmails() async {
//     _getImageSize(File(_imagePath));
//
//     // Creating an InputImage object using the image path
//     final inputImage = InputImage.fromFilePath(_imagePath);
//     // Retrieving the RecognisedText from the InputImage
//     final RecognizedText recognizedText =
//         await _textRecognizer.processImage(inputImage);
//
//     // Pattern of RegExp for matching text
//     String emailPattern =
//         r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
//     String pricePattern = r"^[1-9]\d{0,7}(?:\.\d{1,4})?|\.\d{1,4}$";
//     RegExp regEx = RegExp(emailPattern);
//     RegExp regExPrice = RegExp(pricePattern);
//
//     List<String> emailStrings = [];
//     List<String> priceStrings = [];
//     List<String> allStrings = [];
//     String totalText = "";
//
// // Finding and storing the email addresses, prices, and Total text
//     bool foundTotal = false;
//     for (TextBlock block in recognizedText.blocks) {
//       for (TextLine line in block.lines) {
//         for (TextElement element in line.elements) {
//           if (regEx.hasMatch(element.text)) {
//             emailStrings.add(element.text);
//           }
//           if (regExPrice.hasMatch(element.text)) {
//             priceStrings.add(element.text);
//           }
//           if (foundTotal) {
//             totalText += element.text + " ";
//           }
//           if (element.text.toLowerCase() == "total") {
//             foundTotal = true;
//           }
//         }
//       }
//     }
//
//     setState(() {
//       _listEmailStrings = emailStrings;
//       // Set the extracted text after "Total" to a variable for display or further processing
//       _extractedTotalText = totalText.trim();
//     });
//   }

  void _recognizeText() async {
    _getImageSize(File(_imagePath));

    // Creating an InputImage object using the image path
    final inputImage = InputImage.fromFilePath(_imagePath);
    // Retrieving the RecognisedText from the InputImage
    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);

    List<String> emailStrings = [];
    List<String> priceStrings = [];
    List<String> allStrings = [];
    String totalText = "";
    bool foundTotal = false;

    // Finding and storing all text and the text after "Total"
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          allStrings.add(element.text);

          if (foundTotal) {
            totalText += element.text + " ";
          }
          if (element.text.toLowerCase() == "total") {
            foundTotal = true;
          }
        }
      }
    }

    setState(() {
      _listEmailStrings = emailStrings;
      _listPriceStrings = priceStrings;
      _listAllStrings = allStrings;
      _extractedTotalText = totalText.trim();
    });
  }

  @override
  void initState() {
    _imagePath = widget.imagePath;
    // Initializing the text recognizer
    _textRecognizer = TextRecognizer();
    //_recognizeEmails();
    _recognizeText();
    super.initState();
  }

  @override
  void dispose() {
    // Disposing the text recognizer when not used anymore
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Details"),
      ),
      body: _imageSize != null
          ? Stack(
              children: [
                Container(
                  width: double.maxFinite,
                  color: Colors.black,
                  child: CustomPaint(
                    foregroundPainter: TextDetectorPainter(
                      _imageSize!,
                      _elements,
                    ),
                    child: AspectRatio(
                      aspectRatio: _imageSize!.aspectRatio,
                      child: Image.file(
                        File(_imagePath),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    elevation: 8,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Identified fields",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            height: Adaptive.h(20),
                            child: SingleChildScrollView(
                              child: _listAllStrings != null
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: _listAllStrings!.length,
                                      itemBuilder: (context, index) =>
                                          Text(_listAllStrings![index]),
                                    )
                                  : Container(),
                            ),
                          ),
                        ],
                      ),
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

// Helps in painting the bounding boxes around the recognized
// email addresses in the picture
class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.elements);

  final Size absoluteImageSize;
  final List<TextElement> elements;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(TextElement container) {
      return Rect.fromLTRB(
        container.boundingBox.left * scaleX,
        container.boundingBox.top * scaleY,
        container.boundingBox.right * scaleX,
        container.boundingBox.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (TextElement element in elements) {
      canvas.drawRect(scaleRect(element), paint);
    }

    // Add a box around the text
    final boxPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;

    for (TextElement element in elements) {
      canvas.drawRect(scaleRect(element), boxPaint);
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
  }
}
