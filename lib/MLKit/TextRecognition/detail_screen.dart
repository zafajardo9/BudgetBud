import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:budget_bud/misc/widgetSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../dataModels/transaction_model.dart';
import '../../misc/colors.dart';
import '../../misc/txtStyles.dart';
import '../../pages/category_page/category_list/category_lists.dart';
import '../../pages/transaction_page/tabs/expense_tab.dart';
import 'highlight_selected.dart';

class DetailScreen extends StatefulWidget {
  final String imagePath;

  const DetailScreen({required this.imagePath});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  late final String _imagePath;
  late final TextRecognizer _textRecognizer;
  Size? _imageSize;
  List<String> _listAllStrings = [];
  late final int priceTotalFinal;
  late final String dateFinal;
  String selectedItem = '';
  DateTime _dateTime = DateTime.now();
  String? totalAmount;

  final newScanAmount = TextEditingController();

  List<Rect> _textRects = [];

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
      newScanAmount.text =
          totalAmount ?? '0'; // Update the value in the TextEditingController
    });
  }

  @override
  void initState() {
    _imagePath = widget.imagePath;
    _textRecognizer = TextRecognizer();
    _recognizeText();
    super.initState();

    newScanAmount.text =
        totalAmount ?? '0'; // Set initial value of the TextEditingController
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  //create new transaction

  saveExpense() {
    //getting values
    var expenseAmount = double.parse(newScanAmount.text.trim());

    if (selectedItem.isNotEmpty && expenseAmount > 0) {
      var transaction = TransactionData(
        userEmail: user.email!,
        transactionType: 'Expense',
        description: 'Receipt',
        amount: expenseAmount,
        category: selectedItem,
        transactionDate: _dateTime,
        documentId: '',
      );
      FirebaseFirestore.instance
          .collection('Transactions')
          .add(transaction.toJson());

      FocusScope.of(context).unfocus();

      messageBar();
      _clearTextFields();

      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);

      // Navigator.popUntil(context, (route) {
      //   if (route.settings.name == '/e') {
      //     return true; // Stop popping routes when reaching '/next_page'
      //   }
      //   return false; // Continue popping routes
      // });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Missing Information'),
            content: Text(
                'Please fill in all the required fields and select a category.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _clearTextFields() {
    newScanAmount.clear();
    setState(() {
      selectedItem = ''; // Reset the selected item
    });
  }

  void messageBar() {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success',
        message: 'You have successfully recorded an Expense',

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  //dialog pop

  void onTextFieldTap() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Item',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: expenseCategories.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = expenseCategories[index];
                        final isSelected = selectedItem == item;

                        return ListTile(
                          title: Text(
                            item,
                            style: TextStyle(
                              color:
                                  isSelected ? AppColors.mainColorFour : null,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedItem = item;
                            });
                          },
                          trailing: isSelected
                              ? Icon(Icons.check_circle,
                                  color: AppColors.mainColorFour)
                              : null,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.mainColorFour,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      minimumSize: Size(50.w, 5.h),
                    ),
                    onPressed: () {
                      Navigator.pop(context, selectedItem);
                    },
                    child: Text('Done'),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      if (value != null) {
        // Handle selected item
        String selectedItem = value as String;
        print(selectedItem);
      }
    });
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
                SingleChildScrollView(
                  child: Container(
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
                              height: Adaptive.h(60),
                              child: SingleChildScrollView(
                                child: _listAllStrings != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Receipt Scanned",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Amount',
                                            style: ThemeText.paragraph54,
                                          ),
                                          TextField(
                                            style: ThemeText.textfieldInput,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 1.w,
                                                      horizontal: 4.h),
                                              prefixIcon: Icon(
                                                FontAwesomeIcons.pesoSign,
                                                size: 15,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade400,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                            keyboardType: TextInputType
                                                .number, // Show numeric keyboard
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly // Only allow digits
                                            ],
                                            controller: newScanAmount,
                                          ),
                                          addVerticalSpace(3),
                                          ElevatedButton.icon(
                                            onPressed: onTextFieldTap,
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25), // Rounded corners
                                              ),
                                              minimumSize: Size(100.w, 6.h),
                                            ),
                                            icon: Icon(
                                                Icons.category), // Button icon
                                            label: Text(
                                                'Categories'), // Button label
                                          ),
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
                              onPressed: saveExpense,
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
