import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/view/main_page.dart';

void main() {
  runApp(
      ProviderScope(child: const BasketballRecordsApp())
  );
}

class BasketballRecordsApp extends StatelessWidget {
  const BasketballRecordsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}
