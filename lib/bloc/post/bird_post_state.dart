part of 'bird_post_cubit.dart';


class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit()
      : super(const BirdPostState(
      birdPosts: [], status: BirdPostStatus.initial));

  void addPostBird(BirdModel birdModel){
    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = [...state.birdPosts];

    birdPosts.add(birdModel);
    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loading));

  }
}
