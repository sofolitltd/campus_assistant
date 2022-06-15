import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '/widgets/custom_button.dart';
import '../../../models/teacher_model.dart';
import '../../../models/user_model.dart';

class TeacherDetailsScreen extends StatelessWidget {
  static const routeName = 'teacher_details_screen';

  const TeacherDetailsScreen({
    Key? key,
    required this.userModel,
    required this.teacherModel,
  }) : super(key: key);
  final UserModel userModel;
  final TeacherModel teacherModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          // backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                    onPressed: () async {
                      String shareableText =
                          '${teacherModel.name}\n${teacherModel.post}\n${teacherModel.phd}\n\nMobile: ${teacherModel.mobile}\nEmail: ${teacherModel.email}\n\nPublications: ${teacherModel.publications}\n\nInterest: ${teacherModel.interests}\n\n${teacherModel.imageUrl}';

                      await Share.share(shareableText,
                          subject: 'Profile of ${teacherModel.name}');
                    },
                    icon: const Icon(Icons.share)),
              )
            ],
          ),

          //
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 8)],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Hero(
                              tag: teacherModel.name,
                              child: CachedNetworkImage(
                                imageUrl: teacherModel.imageUrl,
                                fadeInDuration:
                                    const Duration(milliseconds: 500),
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  backgroundImage: imageProvider,
                                  radius: 120,
                                ),
                                progressIndicatorBuilder: (context, url,
                                        downloadProgress) =>
                                    const CircleAvatar(
                                        radius: 120,
                                        backgroundImage: AssetImage(
                                            'assets/images/pp_placeholder.png')),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                        radius: 120,
                                        backgroundImage: AssetImage(
                                            'assets/images/pp_placeholder.png')),
                              ),
                            ),
                          ),

                          //
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                teacherModel.name,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                teacherModel.post,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(height: 4),
                              if (teacherModel.phd.isNotEmpty)
                                Text(
                                  teacherModel.phd,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300),
                                ),

                              const SizedBox(height: 8),

                              //
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(
                                  children: [
                                    //publication
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6))),
                                        onPressed: () async {
                                          final url = teacherModel.publications;
                                          //
                                          if (teacherModel
                                              .publications.isNotEmpty) {
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            }
                                          } else {
                                            Fluttertoast.cancel();
                                            Fluttertoast.showToast(
                                                msg: 'No publication found');
                                            print('no publication found');
                                          }
                                        },
                                        // color: Colors.black,
                                        // padding: const EdgeInsets.symmetric(
                                        //     vertical: 13),
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius:
                                        //         BorderRadius.circular(8)),
                                        child: const Padding(
                                          padding: EdgeInsets.all(13),
                                          child: Text(
                                            "Publication",
                                            style: TextStyle(
                                              fontSize: 16,
                                              // color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    // mail
                                    CustomButton(
                                      type: 'mailto:',
                                      link: teacherModel.email,
                                      icon: Icons.mail,
                                      color: Colors.red,
                                      borderRadius: 8,
                                    ),

                                    const SizedBox(width: 8),

                                    //call
                                    CustomButton(
                                      type: 'tel:',
                                      link: teacherModel.mobile,
                                      icon: Icons.call,
                                      color: Colors.green,
                                      borderRadius: 8,
                                    ),
                                  ],
                                ),
                              ),

                              const Divider(height: 24),

                              const Text(
                                "Mobile: ",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              SelectableText(
                                teacherModel.mobile,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Email: ",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              SelectableText(
                                teacherModel.email,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w300),
                              ),
                              const Divider(height: 24),

                              if (teacherModel.interests.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //
                                    const Text(
                                      "Field of Interest: ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800),
                                    ),

                                    //
                                    const SizedBox(height: 4),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: splitTextToList(
                                              teacherModel.interests.toString())
                                          .map((text) => Row(
                                                children: [
                                                  const Icon(Icons.check,
                                                      size: 16),
                                                  const SizedBox(width: 4),
                                                  Text(text,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w300)),
                                                ],
                                              ))
                                          .toList(),
                                    ),
                                  ],
                                ),
                            ],
                          ),

                          //
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // text split with ,
  List<String> splitTextToList(String text) {
    List<String> result = text.split(',');
    return result;
  }
}
