part of 'bird_post_cubit.dart';

class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit()
      : super(
            const BirdPostState(birdPosts: [], status: BirdPostStatus.initial));

  Future<void> getSavedPosts() async {

    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = [];




    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  void addPostBird(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));
    List<BirdModel> birdPosts = [...state.birdPosts];
    birdPosts.add(birdModel);
    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loading));
  }

  void removeBirdPost(BirdModel birdModel) {
    List<BirdModel> birdPosts = [...state.birdPosts]..remove(birdModel);
    emit(state.copyWith(
        birdPosts: birdPosts, status: BirdPostStatus.postRemoved));
  }


}
