import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spot_the_bird/bloc/location/location_cubit.dart';
import 'package:spot_the_bird/bloc/post/bird_post_cubit.dart';
import 'package:spot_the_bird/screens/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationCubit>(
          create: (ctx) => LocationCubit()..getLocation(),
        ),
        BlocProvider<BirdPostCubit>(create: (ctx) => BirdPostCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

            // appbar
            primaryColor: const Color(0xff557B83),
            colorScheme: const ColorScheme.light().copyWith(
              //text
              primary: const Color(0xffA2D5AB),
              //floatingactionbutton
              secondary: const Color(0xff39AEA9),
            )),
        home: MapScreen(),
      ),
    );
  }
}
