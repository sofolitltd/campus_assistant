import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';

import '/models/course_content_model.dart';
import '/screens/study/widgets/bookmark_button.dart';

class ContentCard extends StatefulWidget {
  const ContentCard(
      {Key? key, required this.contentId, required this.courseContentModel})
      : super(key: key);

  final String contentId;
  final CourseContentModel courseContentModel;

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          //
          final appStorage =
              Directory('/storage/emulated/0/Download/Campus Assistant');
          final file = File(
              '${appStorage.path}/${widget.courseContentModel.contentTitle}.pdf');

          //
          if (file.existsSync()) {
            print('exist');
            await OpenFile.open(file.path);
          } else {
            print('not exist');

            //
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Download File!'),
                      content: const Text(
                          'First time you should  download this file to open.'),
                      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      actions: [
                        //cancel
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),

                        //download
                        TextButton(
                            onPressed: () async {
                              setState(() => _isLoading = true);

                              //
                              Navigator.pop(context);

                              //
                              await downloadAndOpenFile(
                                  url: widget.courseContentModel.fileUrl,
                                  fileName:
                                      '${widget.courseContentModel.contentTitle}.pdf');

                              setState(() => _isLoading = false);
                            },
                            child: const Text('Download')),
                      ],
                    ));
          }
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            //
            Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 10,
                bottom: 10,
                top: 12,
              ),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  //
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // title head
                      Text(
                        'Title',
                        style:
                            Theme.of(context).textTheme.bodySmall!.copyWith(),
                      ),

                      // const SizedBox(height: 2),

                      //title
                      ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 32),
                        child: Text(
                          widget.courseContentModel.contentTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 4),
                      // sub head
                      Text(
                        widget.courseContentModel.contentSubtitleType,
                        style:
                            Theme.of(context).textTheme.bodySmall!.copyWith(),
                      ),

                      // const SizedBox(height: 2),

                      // subtitle
                      Flexible(
                        child: Text(
                          widget.courseContentModel.contentSubtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(),
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Divider(height: 8),

                      // title head
                      Text(
                        'Upload on:',
                        style:
                            Theme.of(context).textTheme.bodySmall!.copyWith(),
                      ),

                      const SizedBox(height: 2),

                      //time
                      Text(widget.courseContentModel.uploadDate,
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),

                  //
                  if (downloadFileChecker(widget.courseContentModel))
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 30,
                    )
                  else
                    (_isLoading == false)
                        ? GestureDetector(
                            onTap: () async {
                              setState(() => _isLoading = true);

                              //
                              await downloadFile(
                                  widget.courseContentModel.fileUrl,
                                  '${widget.courseContentModel.contentTitle}.pdf');

                              //
                              setState(() => _isLoading = false);
                            },
                            child: const Icon(
                              Icons.downloading_rounded,
                              color: Colors.red,
                              size: 30,
                            ),
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: const [
                              Icon(
                                Icons.downloading_rounded,
                                color: Colors.grey,
                                size: 24,
                              ),
                              SizedBox(
                                height: 32,
                                width: 32,
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          ),
                ],
              ),
            ),

            // bookmarks
            BookmarkButton(
              contentId: widget.contentId,
              courseContentModel: widget.courseContentModel,
            ),
          ],
        ),
      ),
    );
  }
}

// downloadFileChecker
downloadFileChecker(courseContentModel) {
  final appStorage = Directory('/storage/emulated/0/Download/Campus Assistant');
  final file =
      File('${appStorage.path}/${courseContentModel.contentTitle}.pdf');

  if (file.existsSync()) {
    return true;
  }
  return false;
}

// downloadAndOpenFile
downloadAndOpenFile({required String url, required String fileName}) async {
  // download file
  final file = await downloadFile(url, fileName);

  //
  if (file == null) return;
  print('path:  $file');
  OpenFile.open(file.path);
}

// download file
Future<File?> downloadFile(String url, String fileName) async {
  // file location
  // final appStorage = await getApplicationDocumentsDirectory();
  final appStorage =
      await Directory('/storage/emulated/0/Download/Campus Assistant')
          .create(recursive: true);
  final file = File('${appStorage.path}/$fileName');

  // download file with dio
  try {
    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: 0,
      ),
    );

    // store on file system
    final ref = file.openSync(mode: FileMode.write);
    ref.writeFromSync(response.data);
    await ref.close();

    //
    Fluttertoast.showToast(msg: 'File save on /Download/Campus Assistant');

    return file;
  } catch (e) {
    print('dio error: $e');
    return null;
  }
}
