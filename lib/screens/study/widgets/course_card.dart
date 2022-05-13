import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/models/course_model.dart';
import '/models/user_model.dart';
import '../course2_type_screen.dart';
import 'course_info.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    Key? key,
    required this.userModel,
    required this.selectedYear,
    required this.id,
    required this.courseModel,
  }) : super(key: key);

  final UserModel userModel;
  final String selectedYear;
  final String id;
  final CourseModel courseModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          //
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseTypeScreen(
                userModel: userModel,
                selectedYear: selectedYear,
                id: id,
                courseModel: courseModel,
              ),
            ),
          );
        },

        //
        child: SizedBox(
          height: 150,
          child: Row(
            children: [
              //
              Expanded(
                flex: 1,
                child: CachedNetworkImage(
                  imageUrl: courseModel.imageUrl,
                  fadeInDuration: const Duration(milliseconds: 500),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        )),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/placeholder.jpg'),
                        // fit: BoxFit.,
                      ),
                    ),
                  ),
                ),
              ),

              //
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Course Title',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          Container(
                            constraints: const BoxConstraints(minHeight: 48),
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * .12,
                            ),
                            child: Text(
                              courseModel.courseTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                // letterSpacing: 0,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Divider(),

                      //
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          courseInfo(
                            'Course Code',
                            courseModel.courseCode,
                          ),
                          courseInfo(
                            'Marks',
                            courseModel.courseMarks,
                          ),
                          courseInfo(
                            'Credits',
                            courseModel.courseCredits,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
