import 'package:flutter/material.dart';

import '/models/user_model.dart';
import '/utils/constants.dart';
import '/widgets/headline.dart';
import '../about/about_screen.dart';
import '../office/office_screen.dart';
import '../student/student_screen.dart';
import '../teacher/teacher_screen.dart';
import '../widgets/category_card.dart';

class Categories extends StatelessWidget {
  const Categories({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //category title
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Headline(title: 'Categories'),
          ),

          //category card grid
          GridView.count(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            childAspectRatio: screenSize.width > 1200 ? 1 : .8,
            crossAxisCount: screenSize.width > 1200 ? 4 : 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              // dept
              CategoryCard(
                title: 'About\nDepartment',
                color: kCardColor1,
                routeName: AboutScreen.routeName,
                args: userModel,
              ),
              CategoryCard(
                title: 'Teacher\nInformation',
                color: kCardColor2,
                routeName: TeacherScreen.routeName,
                args: userModel,
              ),
              CategoryCard(
                title: 'Student\nInformation',
                color: kCardColor3,
                routeName: StudentScreen.routeName,
                args: userModel,
              ),
              CategoryCard(
                title: 'CR &\nOffice staff',
                color: kCardColor4,
                routeName: OfficeScreen.routeName,
                args: userModel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
