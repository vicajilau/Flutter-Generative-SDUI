import 'dart:convert';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../sdui/sdui_engine.dart';

class SduiDemoScreen extends StatefulWidget {
  const SduiDemoScreen({super.key});

  @override
  State<SduiDemoScreen> createState() => _SduiDemoScreenState();
}

class _SduiDemoScreenState extends State<SduiDemoScreen> {
  final TextEditingController _promptController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _generatedSchema;
  String? _errorMessage;
  String? _rawJson;
  bool _showRawJson = false;

  Future<void> _generateUi() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await client.sdui.generateUi(prompt);

      try {
        final decodedMap = jsonDecode(response.jsonSchema);
        setState(() {
          _generatedSchema = decodedMap;
          _rawJson = response.jsonSchema;
        });
      } catch (e) {
        setState(() {
          _errorMessage =
              'Failed to parse JSON: $e\n\nRaw response:\n${response.jsonSchema}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to connect to server: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generative SDUI Example'),
        actions: [
          IconButton(
            icon: Icon(_showRawJson ? Icons.code_off : Icons.code),
            tooltip: 'Toggle Raw JSON View',
            onPressed: () {
              setState(() {
                _showRawJson = !_showRawJson;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Input Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    decoration: const InputDecoration(
                      hintText:
                          'e.g., "A blue button and a red text saying hello"',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _generateUi(),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _generateUi,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Generate'),
                ),
              ],
            ),
          ),
          const Divider(),
          // Result Section
          Expanded(
            child: _errorMessage != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Thinking... (This can take a few seconds)'),
                      ],
                    ),
                  )
                : _generatedSchema == null
                ? const Center(
                    child: Text('Type a prompt to generate a UI!'),
                  )
                : _showRawJson
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Text(_rawJson ?? ''),
                  )
                : Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: SduiEngine.buildWidget(_generatedSchema),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
