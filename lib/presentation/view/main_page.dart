import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boilerplate/presentation/viewmodel/main_page_view_model.dart';
import 'package:gsheets/gsheets.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(mainPageViewModelProvider);
    
    return Scaffold(
      appBar: _appBar(),
      body: dataAsync.when(
        data: (data) => _body(data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(mainPageViewModelProvider.notifier).fetchSheetData(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.red,
      title: const Text('Basketball Records'),
    );
  }

  Widget _body(Spreadsheet data) {
    if (data.sheets.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }
    
    return ListView.builder(
      itemCount: data.sheets.length,
      itemBuilder: (context, index) {
        final sheet = data.sheets[index];
        return ExpansionTile(
          title: Text('Sheet: ${sheet.title}'),
          children: [
            FutureBuilder<List<dynamic>>(
              future: sheet.cells.row(1),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final headers = snapshot.data ?? [];
                return Column(
                  children: [
                    ...headers.map((header) => ListTile(
                      title: Text(header.toString()),
                    )),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
