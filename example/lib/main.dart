import 'package:auto_size_text_community/auto_size_text_community.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  final _group = AutoSizeGroup();
  double _width = 300;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('auto_size_text_community')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Slider(
                value: _width,
                min: 60,
                max: 360,
                onChanged: (width) => setState(() => _width = width),
              ),
              SizedBox(
                width: _width,
                child: const AutoSizeText(
                  'This text shrinks to fit on two lines.',
                  style: TextStyle(fontSize: 30),
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: 24),
              for (final label in ['Short', 'A much longer label'])
                SizedBox(
                  width: _width,
                  child: AutoSizeText(
                    label,
                    group: _group,
                    style: const TextStyle(fontSize: 30),
                    maxLines: 1,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
