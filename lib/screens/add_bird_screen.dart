import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/post/bird_post_cubit.dart';
import 'package:spot_the_bird/models/bird_post_model.dart';

class AddBirdScreen extends StatefulWidget {
  final LatLng latLng;
  final File image;

  AddBirdScreen({required this.latLng, required this.image});

  @override
  State<AddBirdScreen> createState() => _AddBirdScreenState();
}

class _AddBirdScreenState extends State<AddBirdScreen> {
  String? name;
  String? description;
  final _formKey = GlobalKey<FormState>();
  late final FocusNode _descriptionFocusNode;

  @override
  void initState() {
    _descriptionFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Bird"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 1.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(widget.image),
                          fit: BoxFit.cover,
                        )),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration:
                        const InputDecoration(hintText: "Enter a bird name"),
                    onSaved: (value) {
                      name = value!.trim();
                    },
                    onFieldSubmitted: (_) {
                      //move focus
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter a name...";
                      }
                      if (value.length < 2) {
                        return "Please enter a longer name";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _descriptionFocusNode,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      _submit();
                    },
                    decoration: const InputDecoration(
                        hintText: "Enter a bird description"),
                    onSaved: (value) {
                      description = value!.trim();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter a description...";
                      }
                      if (value.length < 2) {
                        return "Please enter a longer description";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.check,
          size: 30,
        ),
        onPressed: () {

          _submit();
        },
      ),
    );
  }

  void _submit() {
    if(!_formKey.currentState!.validate()){
      //invalid
      return;
    }
    _formKey.currentState!.save();
    final birdModel = BirdModel(
      birdName: name,
      latitude: widget.latLng.latitude,
      longitude: widget.latLng.longitude,
      birdDescription: description,
      image: widget.image,
    );
    context.read<BirdPostCubit>().addPostBird(birdModel);
    Navigator.of(context).pop();
  }
}
