enum AppPage {
  main,
  recordAdd,
  playerDetail;
  //...;

  String get path {
    switch (this) {
      case AppPage.main:
        return '/';
      case AppPage.playerDetail:
        return '/playerDetail';
      case AppPage.recordAdd:
        return '/recordAdd';
      // case AppPage.settings:
      //   return '/settings';
    }
  }

  String get name => toString().split('.').last;
}