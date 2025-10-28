import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/env.dart';
import 'core/di/injection.dart';
import 'src/app_router.dart';
import 'src/features/authentication/presentation/providers/auth_provider.dart';
import 'src/state/app_state.dart';
import 'src/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Env.setEnvironment(Environment.dev);

  await setupDependencies();

  runApp(const IGCSELearningHub());
}

class IGCSELearningHub extends StatelessWidget {
  const IGCSELearningHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
      ],
      child: MaterialApp.router(
        title: 'IGCSE Learning Hub',
        theme: buildAppTheme(),
        routerConfig: buildRouter(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
