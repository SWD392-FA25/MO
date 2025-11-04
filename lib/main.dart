import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/state/app_state.dart';

void main() {
  runApp(const IGCSELearningHub());
}

class IGCSELearningHub extends StatelessWidget {
  const IGCSELearningHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppState())],
      child: MaterialApp.router(
        title: 'IGCSE Learning Hub',
        theme: buildAppTheme(),
        routerConfig: buildRouter(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
