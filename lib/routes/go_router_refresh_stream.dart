import 'package:flutter/cupertino.dart';

//écouter les changements de mon bloc et informer go_router des changements
class GoRouterRefreshStream extends ChangeNotifier{
  GoRouterRefreshStream(Stream<dynamic> stream) {
    stream.listen((_) {
      notifyListeners();
    });
  }
}