import 'package:flutter/material.dart';

import '../models/bird_post_model.dart';

class BirdPostInfoScreen extends StatelessWidget {
  final BirdModel birdModel;
  const BirdPostInfoScreen({Key? key, required this.birdModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(birdModel.birdName!),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 1.4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: FileImage(birdModel.image),
                    fit: BoxFit.cover,
                  )),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(birdModel.birdName!, style: Theme.of(context).textTheme.headline5,),
            const SizedBox(
              height: 5,
            ),
            Text(birdModel.birdDescription!, style: Theme.of(context).textTheme.headline6,),
            const SizedBox(
              height: 5,
            ),
            TextButton(
                onPressed: (){
                  //todo delete this post
                },
                child: const Text("Delete"),
            )
          ],
        ),
      ),
    );
  }
}
