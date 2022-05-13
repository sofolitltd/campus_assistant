import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_assistant/models/student_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({Key? key, required this.studentModel}) : super(key: key);

  final StudentModel studentModel;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            //image
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FullImage(imageUrl: studentModel.imageUrl)));
                  },
                  child: CachedNetworkImage(
                    height: 100,
                    fit: BoxFit.cover,
                    imageUrl: studentModel.imageUrl,
                    fadeInDuration: const Duration(milliseconds: 500),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/pp_placeholder.png',
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            //info
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //name
                  Text(
                    studentModel.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),

                  //id
                  const Text('Student ID', style: TextStyle(fontSize: 12)),
                  Text(
                    studentModel.id,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),

                  //hall
                  if ((studentModel.hall != 'None'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hall', style: TextStyle(fontSize: 12)),
                        Text(
                          studentModel.hall,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

// call and message button
// Row buildRow() {
//   return Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       // shape: BoxShape.circle,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(
//                       Icons.call,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Container(
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.indigoAccent,
//                       // shape: BoxShape.circle,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(
//                       Icons.message,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               );
// }
}

//
class FullImage extends StatelessWidget {
  final String imageUrl;

  const FullImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onDoubleTap: () {
          Navigator.pop(context);
        },
        child: SafeArea(
          child: Center(
            child: CachedNetworkImage(
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              imageUrl: imageUrl,
              fadeInDuration: const Duration(milliseconds: 500),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  const CupertinoActivityIndicator(),
              errorWidget: (context, url, error) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/pp_placeholder.png',
                    fit: BoxFit.cover,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
