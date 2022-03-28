import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/bird_post_model.dart';

part 'bird_post_state.dart';

enum BirdPostStatus { initial, error, loading, loaded, postAdded, postRemoved }

class BirdPostState extends Equatable {
  final List<BirdModel> birdPosts;
  final BirdPostStatus status;

  const BirdPostState({required this.birdPosts, required this.status});

  @override
  List<Object> get props => [birdPosts, status];

  BirdPostState copyWith({List<BirdModel>? birdPosts, BirdPostStatus? status}) {

    return BirdPostState(
        birdPosts: birdPosts ?? this.birdPosts,
        status: status ?? this.status,
    );
  }
}


