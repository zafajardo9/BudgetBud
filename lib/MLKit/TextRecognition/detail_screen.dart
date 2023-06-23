import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../pages/transaction_page/tabs/expense_tab.dart';
import 'highlight_selected.dart';

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
  List<String> _listAllStrings = [];
  late final int priceTotalFinal;
  late final String dateFinal;

  List<Rect> _textRects = [];

  String? totalAmount;

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

  void _recognizeText() async {
    _getImageSize(File(_imagePath));

    // Creating an InputImage object using the image path
    final inputImage = InputImage.fromFilePath(_imagePath);
    // Retrieving the RecognisedText from the InputImage
    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);

    // Variables
    num scanTotal = 0;
    RegExp moneyExp = RegExp(r"([0-9]{1,3}\.[0-9]{2})");

    // Finding and storing the scanTotal (largest number)
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        final String text = line.text;
        final moneyMatch = moneyExp.firstMatch(text);
        if (moneyMatch != null) {
          final num lineCost = num.parse(moneyMatch.group(0)!);
          if (lineCost > scanTotal) {
            scanTotal = lineCost;
            _textRects.add(line.boundingBox!);
            print('Got rects');
          }
        }
      }
    }

    setState(() {
      totalAmount =
          scanTotal > 0 ? scanTotal.toString() : 'Total Amount not found';
    });
  }

  @override
  void initState() {
    _imagePath = widget.imagePath;
    _textRecognizer = TextRecognizer();
    _recognizeText();
    super.initState();
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipt Details"),
        elevation: 0,
      ),
      body: _imageSize != null
          ? Stack(
              children: [
                Container(
                  width: double.maxFinite,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      CustomPaint(
                        painter: HighlightPainter(_textRects),
                        size: _imageSize!,
                      ),
                      AspectRatio(
                        aspectRatio: _imageSize!.aspectRatio,
                        child: Image.file(
                          File(_imagePath),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(
                              0), // Adjust the opacity for the desired blur effect
                        ),
                      ),
                    ],
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
                            child: Container(
                              width: Adaptive.w(90),
                              height: Adaptive.h(15),
                              child: SingleChildScrollView(
                                child: _listAllStrings != null
                                    ? Column(
                                        children: [
                                          Text(
                                            "Total Amount Detected",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          Text(totalAmount ?? ''),
                                        ],
                                      )
                                    : Container(),
                              ),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExpenseTab(),
                                    settings: RouteSettings(
                                        arguments: totalAmount ?? ''),
                                  ),
                                );
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
