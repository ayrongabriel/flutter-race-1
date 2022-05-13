import 'package:flutter/cupertino.dart';
import 'package:meuapp/modules/home/pages/feed/repository/feed_repository.dart';

import 'package:meuapp/shared/utils/app_state.dart';

class ThumbnailController extends ChangeNotifier {
  AppState state = AppState.empty();
  FeedRepository repository;

  ThumbnailController({
    required this.repository,
  });

  void update(AppState state) {
    this.state = state;
    notifyListeners();
  }

  Future<void> thumbnailUrl({required String thumbName}) async {
    try {
      update(AppState.loading());
      final response = await repository.thumbnailUrl(thumbName: thumbName);
      update(AppState.success<String?>(response));
    } catch (e) {
      update(AppState.error(e.toString()));
    }
  }
}
