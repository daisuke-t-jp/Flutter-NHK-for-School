import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nhk_for_school/widget/bottom_tab.dart';
import 'package:nhk_for_school/model/state_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FavoriteInfoStateModel favoriteInfoState = FavoriteInfoStateModel();

  final FavoriteStateModel appState = FavoriteStateModel();
  appState.favoriteInfoState = favoriteInfoState;
  await appState.load();

  runApp(NHKForSchoolApp(appState: appState, favoriteInfoState: favoriteInfoState));
}

class NHKForSchoolApp extends StatelessWidget {
  const NHKForSchoolApp(
      {Key? key, required this.appState, required this.favoriteInfoState})
      : super(key: key);
  final FavoriteStateModel appState;
  final FavoriteInfoStateModel favoriteInfoState;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<FavoriteStateModel>(
            create: (context) => appState,
          ),
          ChangeNotifierProvider<FavoriteInfoStateModel>(
            create: (context) => favoriteInfoState,
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '',
          theme: ThemeData(primarySwatch: Colors.green),
          home: const BottomTabPage(),
        ));
  }
}
