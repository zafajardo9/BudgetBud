import 'dart:convert';
import 'dart:io';

import 'package:budget_bud/misc/colors.dart';
import 'package:budget_bud/misc/txtStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'model/news_model.dart';

class DashBoardNews extends StatefulWidget {
  const DashBoardNews({Key? key}) : super(key: key);

  @override
  State<DashBoardNews> createState() => _DashBoardNewsState();
}

class _DashBoardNewsState extends State<DashBoardNews> {
  List<NewsModel> articles = [];
  bool isLoading = false;
  bool hasError = false;

  Future<void> fetchNews() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final String apiKey = '81cf656878534b15aa5b5ef0898add0d';
      final String apiUrl =
          'https://newsapi.org/v2/everything?q=trending+products&language=en&apiKey=$apiKey';

      final response = await get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> articlesData = jsonData['articles'];
        setState(() {
          articles = articlesData
              .map((articleJson) => NewsModel.fromJson(articleJson))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Your Daily News'),
        elevation: 0,
      ),
      body: LiquidPullToRefresh(
        color: AppColors.mainColorOneSecondary,
        height: 300,
        backgroundColor: AppColors.mainColorFour,
        onRefresh: fetchNews,
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.stretchedDots(
                  color: AppColors.mainColorOne,
                  size: 50,
                ),
              )
            : hasError
                ? Center(
                    child: Text(
                      'Failed to load news',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.backgroundWhite,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(
                                    0, 3), // changes the position of the shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(16.0),
                                leading: article.imageUrl != null &&
                                        Uri.parse(article.imageUrl!).isAbsolute
                                    ? Image.network(
                                        article.imageUrl!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          // Placeholder image when image fails to load
                                          return Image.asset(
                                            'assets/no-image-found.png',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.contain,
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        'assets/no-image-found.png',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.contain,
                                      ),
                                title: Text(
                                  article.title ?? 'No enough Data',
                                  style: ThemeText.subHeader3Bold,
                                ),
                                subtitle: Text(
                                  'Author: ${article.author ?? 'No enough Data'}',
                                  style: ThemeText.paragraph54,
                                ),
                              ),
                              ExpansionTile(
                                title: Text(
                                  'Description',
                                  style: ThemeText.subHeader3Bold,
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Text(
                                      article.description ?? 'No enough Data',
                                      style: ThemeText.paragraph54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
