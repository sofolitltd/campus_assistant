import 'package:flutter/material.dart';

import '/models/content_model.dart';
import '/models/user_model.dart';
import '/widgets/open_app.dart';
import 'bookmark_button.dart';

class ContentCardWeb extends StatelessWidget {
  final String contentId;
  final UserModel userModel;
  final ContentModel courseContentModel;

  const ContentCardWeb({
    Key? key,
    required this.contentId,
    required this.userModel,
    required this.courseContentModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          OpenApp.openPdf(courseContentModel.fileUrl);
        },
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            //
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Row(
                children: [
                  //
                  //
                  Expanded(
                    flex: 3,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        //
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: courseContentModel.imageUrl.isEmpty
                              ? Image.asset(
                                  'assets/images/placeholder.jpg',
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  courseContentModel.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                        ),

                        //
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 4,
                          ),
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(courseContentModel.courseCode,
                              style: Theme.of(context).textTheme.labelMedium),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  //
                  Expanded(
                    flex: 7,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            //title
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: 32,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: Text(
                                  courseContentModel.contentTitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),

                            const SizedBox(height: 2),

                            // sub
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: 30,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  text:
                                      '${courseContentModel.contentSubtitleType}:  ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontSize: 12,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: courseContentModel.contentSubtitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(),
                                    )
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            const Divider(height: 8),

                            // title head
                            Row(
                              children: [
                                //
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Course:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(fontSize: 12),
                                    ),

                                    //course
                                    Text('Psy ${courseContentModel.courseCode}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                  ],
                                ),

                                const VerticalDivider(
                                  thickness: 2,
                                ),

                                //
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Upload on:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(color: Colors.grey),
                                    ),

                                    //time
                                    Text(courseContentModel.uploadDate,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // bookmark
            Positioned(
              top: 0,
              right: 0,
              child: BookmarkButton(
                contentId: contentId,
                userModel: userModel,
                courseContentModel: courseContentModel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
