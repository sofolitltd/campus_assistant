import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';

import '/models/content_model.dart';
import '/models/user_model.dart';
import 'bookmark_button.dart';

class ContentCard extends StatefulWidget {
  const ContentCard({
    Key? key,
    required this.contentId,
    required this.userModel,
    required this.courseContentModel,
  }) : super(key: key);

  final String contentId;
  final UserModel userModel;
  final ContentModel courseContentModel;

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool _isLoading = false;
  double? _downloadProgress;
  CancelToken cancelToken = CancelToken();

  @override
  Widget build(BuildContext context) {
    String fileName =
        '${widget.courseContentModel.courseCode}_${widget.courseContentModel.contentTitle.replaceAll(RegExp('[^A-Za-z0-9]'), ' ')}_${widget.courseContentModel.contentSubtitle}_${widget.contentId.toString().substring(0, 5)}.pdf';

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

          final file = File('${appStorage.path}/$fileName');

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
                                  fileName: fileName);

                              setState(() => _isLoading = false);
                            },
                            child: const Text('Download')),
                      ],
                    ));
          }
        },
        child: Stack(
          children: [
            //
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Row(
                children: [
                  //
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: widget.courseContentModel.imageUrl.isEmpty
                          ? Image.asset(
                              'assets/images/placeholder.jpg',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              widget.courseContentModel.imageUrl,
                              fit: BoxFit.cover,
                            ),
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
                                padding: const EdgeInsets.only(right: 24),
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
                            ),

                            const SizedBox(height: 4),

                            // sub
                            Text.rich(
                              TextSpan(
                                text:
                                    '${widget.courseContentModel.contentSubtitleType}:  ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 12,
                                    ),
                                children: [
                                  TextSpan(
                                    text: widget
                                        .courseContentModel.contentSubtitle,
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

                            const Divider(height: 8),

                            //
                            // title head
                            Row(
                              children: [
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
                                    Text(widget.courseContentModel.uploadDate,
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
                                      'Upload by:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(color: Colors.grey),
                                    ),

                                    //time
                                    Text(widget.courseContentModel.uploader,
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
                contentId: widget.contentId,
                userModel: widget.userModel,
                courseContentModel: widget.courseContentModel,
              ),
            ),

            // download button
            if (downloadFileChecker(fileName: fileName))
              const Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    // size: 30,
                  ),
                ),
              )
            else
              (_isLoading == false)
                  ? Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () async {
                          setState(() => _isLoading = true);

                          //
                          await downloadFile(
                              widget.courseContentModel.fileUrl, fileName);

                          //
                          setState(() => _isLoading = false);
                        },
                        icon: const Icon(
                          Icons.downloading_rounded,
                          color: Colors.red,
                          // size: 30,
                        ),
                      ),
                    )
                  : Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () async {
                          //

                          // cancelToken.cancel();
                        },
                        icon: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              // Icons.clear,
                              Icons.downloading_rounded,
                              color: Colors.grey,
                              size: 18,
                            ),
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                value: _downloadProgress,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
          ],
        ),
      ),
    );
  }

// downloadFileChecker
  downloadFileChecker({required String fileName}) {
    final appStorage =
        Directory('/storage/emulated/0/Download/Campus Assistant');

    final file = File('${appStorage.path}/$fileName');

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
      final response = await Dio().get(url,
          // cancelToken: cancelToken,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          ), onReceiveProgress: (received, total) {
        double progress = received / total;
        setState(() {
          _downloadProgress = progress;
        });
      });

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
}
