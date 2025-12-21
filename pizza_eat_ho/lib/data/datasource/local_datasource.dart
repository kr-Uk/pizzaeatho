class LocalDataSource {
  // /// 캐싱한 게시물을 가져온다.
  // Future<List<Post>> getCachedPosts() async {
  //   var postBox = await Hive.box<Post>('postBox');
  //   return postBox.values.toList();
  // }
  //
  // /// 기존에 캐싱된 게시물들을 모두 삭제하고 새로운 게시물을 캐싱한다.
  // Future<void> updateCachedPosts(List<Posts> posts) async {
  //   var postBox = await Hive.box<Post>('postBox');
  //   await postBox.clear()
  //   await postBox.addAll(posts)
  // }
}