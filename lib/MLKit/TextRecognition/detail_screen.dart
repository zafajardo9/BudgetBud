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
  List<String> _listDateStrings = [];
  List<String> _listPriceStrings = [];
  List<String> _listNameStrings = [];

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

  double _extractPriceValue(String priceString) {
    final pricePattern = r'(?:₱|Php|PHP|P|\$)(\d+(\.\d{2})?)';
    final priceMatch = RegExp(pricePattern).firstMatch(priceString);
    if (priceMatch != null) {
      final value = double.tryParse(priceMatch.group(1) ?? '');
      if (value != null) {
        return value;
      }
    }
    return 0;
  }

  void _recognizeText() async {
    _getImageSize(File(_imagePath));

    // Creating an InputImage object using the image path
    final inputImage = InputImage.fromFilePath(_imagePath);
    // Retrieving the RecognisedText from the InputImage
    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);

    List<String> dateStrings = [];
    List<String> priceStrings = [];
    List<String> nameStrings = [];
    List<String> allStrings = [];
    String totalText = "";
    bool foundTotal = false;

    // Regular expression pattern to match price texts (e.g., $10.99)
    final priceRegex = r'(?:₱|Php|PHP|P|\$)\d+(\.\d{2})?';

    final nameRegex = r'([\w\s]+)';
    final dateRegex = r'(\d{1,2}/\d{1,2}/\d{2,4})';

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

          // Checking if the element text matches the price regex pattern
          if (RegExp(priceRegex).hasMatch(element.text)) {
            final String previousText = line.elements
                .takeWhile((e) => e.text != element.text)
                .map((e) => e.text)
                .join(" ");

            if (previousText.toLowerCase().contains("total amount") ||
                previousText.toLowerCase().contains("total")) {
              priceStrings.add(element.text);
            }
          }

          if (RegExp(priceRegex).hasMatch(element.text)) {
            priceStrings.add(element.text);
          }

          if (RegExp(nameRegex).hasMatch(element.text)) {
            nameStrings.add(element.text);
          }

          if (RegExp(dateRegex).hasMatch(element.text)) {
            dateStrings.add(element.text);
          }
        }
      }
    }

    setState(() {
      _listNameStrings = nameStrings;
      _listDateStrings = dateStrings;
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Card(
                      elevation: 8,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                        ? Column(
                                            children: [
                                              Text(
                                                "Expense Name",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemCount: _listPriceStrings!
                                                            .length >
                                                        2
                                                    ? 2
                                                    : _listPriceStrings!.length,
                                                itemBuilder: (context, index) =>
                                                    Text(_listPriceStrings![
                                                        index]),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                "PRICE",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemCount:
                                                    _listPriceStrings!.length,
                                                itemBuilder: (context, index) {
                                                  final priceString =
                                                      _listPriceStrings![index];
                                                  final priceValue =
                                                      _extractPriceValue(
                                                          priceString);
                                                  return Text(
                                                      priceValue.toString());
                                                },
                                              ),
                                              SizedBox(height: 10),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "DATE",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemCount:
                                                    _listDateStrings!.length,
                                                itemBuilder: (context, index) =>
                                                    Text(_listDateStrings![
                                                        index]),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all(CircleBorder()),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(2.h)), // <-- Button color
                              ),
                              onPressed: () {
                                // Button action
                              },
                              child: Icon(Icons.send_rounded),
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
