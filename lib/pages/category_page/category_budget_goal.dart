import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../misc/colors.dart';
import '../../misc/txtStyles.dart';
import 'category_list/category_lists.dart';

class CategoriesBudget extends StatelessWidget {
  const CategoriesBudget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Category List'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: incomeCategories.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: AppColors.backgroundWhite,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mainColorOne.withOpacity(0.5),
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
                          title: Text(
                            budgetingGoals[index]['category']!,
                            style: ThemeText.categoriesTitle,
                          ),
                          leading: SvgPicture.asset(
                            'assets/budgetCategory/${index + 1}.svg',
                            height: 4.h,
                            color: Colors.black54,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: ExpansionTile(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            collapsedShape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            textColor: Colors.black54,
                            title: Text(
                              'Description',
                              style: ThemeText.categoriesDescripTitle,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  budgetingGoals[index]['description']!,
                                  style: ThemeText.categoriesDescription,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
