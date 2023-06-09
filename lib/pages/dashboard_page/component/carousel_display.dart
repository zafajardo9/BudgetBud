import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

class CarouselContainer extends StatefulWidget {
  final double balance;
  final double totalIncome;
  final double totalExpense;

  CarouselContainer({
    required this.balance,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  _CarouselContainerState createState() => _CarouselContainerState();
}

class _CarouselContainerState extends State<CarouselContainer> {
  final PageController _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                _currentPageNotifier.value = page;
              },
              children: [
                // Overall Transactions
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Balance',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '₱${widget.balance.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transactions',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Total Income: ₱${widget.totalIncome.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.green),
                          ),
                          Text(
                            'Total Expense: ₱${widget.totalExpense.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Monthly Transactions (you can add more pages if needed)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Balance',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '₱9876.54',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transactions',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Total Income: ₱2468.10',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.green),
                          ),
                          Text(
                            'Total Expense: ₱7410.44',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            PageViewDotIndicator(
              selectedColor: Colors.blue,
              count: 2, // Number of pages in the PageView
              currentItem: _currentPageNotifier.value,
              duration: Duration(milliseconds: 200),
              unselectedColor: Colors.blue.withOpacity(.7),
              boxShape: BoxShape.rectangle,
            ),
          ],
        ),
      ),
    );
  }
}
