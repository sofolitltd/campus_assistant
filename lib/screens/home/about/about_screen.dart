import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = 'about_screen';

  const AboutScreen({Key? key, this.department}) : super(key: key);

  final String? department;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About '),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(

          ///Universities/University of Chittagong/Departments/Department of Psychology
          stream: FirebaseFirestore.instance
              .collection('Universities')
              .doc('University of Chittagong')
              .collection('Departments')
              .doc('Department of Psychology')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('some thing wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            var data = snapshot.data;

            return Column(
              children: [
                //
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Image.network(
                      data!.get('imageUrl'),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),

                    //
                    Container(
                      width: double.infinity,
                      color: Colors.grey.shade100.withOpacity(.7),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        data.id,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                //image

                //
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(data.get('about')),
                )
              ],
            );
          }),
    );
  }
}
