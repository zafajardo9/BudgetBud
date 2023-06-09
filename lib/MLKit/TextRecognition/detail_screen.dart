import 'dart:async';
import 'dart:io';
import 'dart:ui';

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
  List<String> _listAllStrings = [];

  late final int priceTotalFinal;
  late final String dateFinal;

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

  // double _extractPriceValue(String priceString) {
  //   final pricePattern = r'(?:₱|Php|PHP|P|\$)(\d+(\.\d{2})?)';
  //   final priceMatch = RegExp(pricePattern).firstMatch(priceString);
  //   if (priceMatch != null) {
  //     final value = double.tryParse(priceMatch.group(1) ?? '');
  //     if (value != null) {
  //       return value;
  //     }
  //   }
  //   return 0;
  // }

  void _recognizeText() async {
    _getImageSize(File(_imagePath));

    // Creating an InputImage object using the image path
    final inputImage = InputImage.fromFilePath(_imagePath);
    // Retrieving the RecognisedText from the InputImage
    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);

    String? date;

    String noData = 'No Data. Can be a Problem on our side or not clear photo';

    final totalExp = RegExp(r"([Tt][Oo][Tt][Aa][Ll])");
    final priceRegex = r'(?:₱|Php|PHP|P|\$)\d+(\.\d{2})?';
    final dateRegex = r'(\d{1,2}/\d{1,2}/\d{2,4})';

    List<String> priceMatches = [];

// Finding and storing the total price
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        final String text = line.text;

        // Check for total price
        if (totalExp.hasMatch(text)) {
          final Iterable<RegExpMatch> matches =
              RegExp(priceRegex).allMatches(text);
          for (RegExpMatch match in matches) {
            priceMatches.add(match.group(0)!);
          }
        }

        // Check for date
        final dateMatch = RegExp(dateRegex).firstMatch(text);
        if (dateMatch != null) {
          date = dateMatch.group(0);
        }
      }
    }
    String? totalPrice = priceMatches.isNotEmpty ? priceMatches.last : null;

    setState(() {
      _listPriceStrings = totalPrice != null ? [totalPrice] : [noData];
      _listDateStrings = date != null ? [date] : [noData];
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
        title: Text("Receipt Details"),
      ),
      body: _imageSize != null
          ? Stack(
              children: [
                Container(
                  width: double.maxFinite,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: _imageSize!.aspectRatio,
                        child: Image.file(
                          File(_imagePath),
                        ),
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: 5,
                              sigmaY:
                                  5), // Adjust the sigma values for the desired blur effect
                          child: Container(
                            color: Colors.black.withOpacity(
                                0), // Adjust the opacity for the desired blur effect
                          ),
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
                                  height: Adaptive.h(50),
                                  child: SingleChildScrollView(
                                    child: _listAllStrings != null
                                        ? Column(
                                            children: [
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
                                                itemBuilder: (context, index) =>
                                                    Text(_listPriceStrings![
                                                        index]),
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
