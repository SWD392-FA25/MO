import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as legacy_provider;
import 'app/app.dart';
import 'src/state/app_state.dart';

void main() {
  runApp(
    ProviderScope(
      child: legacy_provider.ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const LearningHubApp(),
      ),
    ),
  );
}
