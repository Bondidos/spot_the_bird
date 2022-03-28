part of 'bird_post_cubit.dart';

class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit()
      : super(
            const BirdPostState(birdPosts: [], status: BirdPostStatus.initial));

  Future<void> getSavedPosts() async {

    emit(state.copyWith(status: BirdPostStatus.loading));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? jsonListOfSavedPosts = prefs.getStringList("birdPosts");

    List<BirdModel> birdPosts = [];

    if (jsonListOfSavedPosts != null) {
      for (String jsonBird in jsonListOfSavedPosts) {
        Map<String, dynamic> bufferBird =
            json.decode(jsonBird) as Map<String, dynamic>;

        File? image = File(bufferBird['imagePass']);
        double latitude = bufferBird["latitude"];
        double longitude = bufferBird["longitude"];
        String birdDescription = bufferBird["birdDescription"];
        String birdName = bufferBird["birdName"];

        birdPosts.add(
          BirdModel(
              birdName: birdName,
              latitude: latitude,
              longitude: longitude,
              birdDescription: birdDescription,
              image: image),
        );
      }
    }
    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  void addPostBird(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));
    List<BirdModel> birdPosts = [...state.birdPosts];
    birdPosts.add(birdModel);
    _saveToPrefs(birdPosts);
    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loading));
  }

  void removeBirdPost(BirdModel birdModel) {
    List<BirdModel> birdPosts = [...state.birdPosts]..remove(birdModel);
    _saveToPrefs(birdPosts);
    emit(state.copyWith(
        birdPosts: birdPosts, status: BirdPostStatus.postRemoved));
  }

  Future<void> _saveToPrefs(List<BirdModel> birdPosts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> jsonDataList = birdPosts
        .map((e) => json.encode({
              "birdName": e.birdName,
              "latitude": e.latitude,
              "longitude": e.longitude,
              "birdDescription": e.birdDescription,
              "imagePass": e.image.path,
            }))
        .toList();
    prefs.setStringList("birdPosts", jsonDataList);
  }
}
