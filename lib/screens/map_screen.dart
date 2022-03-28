import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/location/location_cubit.dart';
import 'package:spot_the_bird/bloc/post/bird_post_cubit.dart';
import 'package:spot_the_bird/models/bird_post_model.dart';
import 'add_bird_screen.dart';
import 'bird_info_screen.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);

  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LocationCubit, LocationState>(
        listener: (previousState, currentState) {
          if (currentState is LocationLoaded) {
            _mapController.onReady.then((value) => _mapController.move(
                LatLng(currentState.latitude, currentState.longitude), 14));
          }

          if (currentState is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.red.withOpacity(0.6),
                content: const Text("Error, unnable to fetch location"),
              ),
            );
          }
        },
        child: BlocBuilder<BirdPostCubit, BirdPostState>(
          buildWhen: (prevState, currentState) => (currentState != prevState),
          builder: (ctx, birdPostState) => FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              onLongPress: (tapPos, latLng) {
                _pickImageAndCreatePost(latLng: latLng, context: context);
              },
              center: LatLng(0, 0),
              zoom: 15.3,
              maxZoom: 17,
              minZoom: 3.5,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                attributionBuilder: (_) {
                  return const Text("© OpenStreetMap contributors");
                },
                retinaMode: true,
              ),
              MarkerLayerOptions(
                markers: _buildMarkers(context, birdPostState.birdPosts),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageAndCreatePost(
      {required LatLng latLng, required BuildContext context}) async {
    File? image;
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 40);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      // navigate

      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => AddBirdScreen(
                latLng: latLng,
                image: image!,
              )));
    } else {
      print("User didn't picked image");
    }
  }

  List<Marker> _buildMarkers(BuildContext context, List<BirdModel> birdPosts) {
    List<Marker> markers = [];
    for (var post in birdPosts) {
      markers.add(
        Marker(
          width: 55,
          height: 55,
          point: LatLng(post.latitude, post.longitude),
          builder: (ctx) => GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => BirdPostInfoScreen(
                    birdModel: post,
                  ),
                ),
              );
            },
            child: Container(
              child: Image.asset("assets/bird_icon.png"),
            ),
          ),
        ),
      );
    }

    return markers;
  }
}
