part of 'bird_post_cubit.dart';

class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit()
      : super(
            const BirdPostState(birdPosts: [], status: BirdPostStatus.initial));

  final dbHelper = DatabaseHelper.instance;

  Future<void> getSavedPosts() async {
    emit(state.copyWith(status: BirdPostStatus.loading));
    List<BirdModel> birdPosts = [];

    final List<Map<String, dynamic>> jsonList = await dbHelper.queryAllRows();

    if (jsonList.isNotEmpty) {
      for (var item in jsonList) {
        birdPosts.add(
          BirdModel(
              birdName: item["birdName"],
              latitude: item["latitude"],
              longitude: item["longitude"],
              birdDescription: item["birdDescription"],
              image: File(item["url"])),
        );
      }
    }

    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  void addPostBird(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));
    List<BirdModel> birdPosts = [...state.birdPosts, birdModel];

    Map<String, dynamic> item = <String, dynamic>{
      DatabaseHelper.columnTitle: birdModel.birdName,
      DatabaseHelper.latitude: birdModel.latitude,
      DatabaseHelper.longitude: birdModel.longitude,
      DatabaseHelper.columnDescription: birdModel.birdDescription,
      DatabaseHelper.columnUrl: birdModel.image.path,
      DatabaseHelper.columnId: birdPosts.indexOf(birdModel),
    };
    await dbHelper.insert(item);
    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loading));
  }

  void removeBirdPost(BirdModel birdModel) async {
    List<BirdModel> birdPosts = [...state.birdPosts];
    await dbHelper.deleteRow(birdPosts.indexOf(birdModel));
    birdPosts.remove(birdModel);
    emit(state.copyWith(
        birdPosts: birdPosts, status: BirdPostStatus.postRemoved));
  }
}
